//
//  StoreView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct StoreView: View {
    @ObservedObject private var vm: StoreViewModel
    @ObservedObject var cartModelVM: CartViewModel

    @State private var showingLanguageSwitcher = false
    @State private var showingCart = false
    @State private var showAddedToCart = false
    @State private var alertProductName = ""
    @FocusState private var isSearchFocused

    public init(vm: StoreViewModel, cartModelVM: CartViewModel) {
        self.vm = vm
        self.cartModelVM = cartModelVM
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                // Content area with gradient overlay
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 10) {
                            Spacer() // 👈 Top inset
                            // Banner
                            BannerView(bannerItem: vm.bannerItem,
                                       storeURL: vm.storeURL)

                        // Categories
                        if vm.isLoadingCategories {
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text(vm.langHandler.localized("loading_categories"))
                                    .font(.subheadline)
                                    .foregroundColor(Color(.secondaryLabel))
                                    .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                        } else {
                            categoriesView
                        }

                        // Products
                        productsView
                        }
                    .padding(.horizontal, vm.horizontalPadding)
                }.onTapGesture {
                    isSearchFocused = false
                }

                // Gradient overlay - positioned above scroll content
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground).opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 20)
                .allowsHitTesting(false) // Allow touches to pass through to scroll view
            }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Force full screen on iPad
        .task {
            await vm.loadCategories()
        }
        .sheet(isPresented: $showingLanguageSwitcher) {
            LanguageSwitcherView(localization: vm.langHandler)
        }
        .sheet(isPresented: $showingCart) {
            NavigationStack {
                CartView(vm: cartModelVM)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("UniFi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    showingLanguageSwitcher = true
                }) {
                    HStack(spacing: 4) {
                        Text(vm.langHandler.currentLanguage.flag)
                            .font(.title3)
                        Text(vm.langHandler.currentLanguage.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Cart Button
                Button(action: {
                    showingCart = true
                }) {
                    ZStack {
                        Image(systemName: "cart")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        if cartModelVM.totalItems > 0 {
                            Text("\(cartModelVM.totalItems)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }

            }
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField(vm.langHandler.localized("search_products_placeholder"),
                          text: $vm.searchText)
                    .focused($isSearchFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !vm.searchText.isEmpty {
                    Button(action: {
                        vm.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal, vm.horizontalPadding)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private var categoriesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(vm.langHandler.localized("categories"))
                .font(.headline)
                .fontWeight(.semibold)

            if let errorMessage = vm.categoriesErrorMsg {
                ErrorView(errorMessage: errorMessage,
                          localizer: vm.langHandler,
                          padding: vm.horizontalPadding) {
                    Task {
                        await vm.loadCategories()
                    }
                }.frame(maxWidth: .infinity) // 👈 Full width
                    .padding(vm.horizontalPadding)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(vm.categories) { category in
                            CategoryCard(
                                category: category,
                                isSelected: vm.selectedCategoryId == category.id
                            ) {
                                Task {
                                    await vm.selectCategory(category)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
    
    private var productsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(vm.langHandler.localized("products"))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                if !vm.products.isEmpty {
                    Text(String(format: vm.langHandler.localized("items_count"), vm.filteredProducts.count))
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            
            if vm.isLoadingProducts {
                loadingView
            } else if vm.filteredProducts.isEmpty {
                emptyStateView
            } else {
                productsGrid
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.2)
            Text(vm.langHandler.localized("loading_products"))
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "shippingbox")
                .font(.system(size: 48))
                .foregroundColor(Color(.secondaryLabel))
            
            Text(vm.langHandler.localized(vm.langHandler.localized("no_products_available")))
                .font(.headline)
                .fontWeight(.medium)
            
            Text(vm.langHandler.localized("no_products_in_category"))
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(vm.filteredProducts) { product in
//            NavigationLink(value: product) {
//                ProductCard(product: product,
//                            imgRepository: UImageRepository(),
//                            localizer: vm.langHandler,
//                            cartViewModel: cartModelVM)
//                .frame(maxWidth: .infinity)
//                .contentShape(Rectangle()) // Ensures full area is tappable
//                .background(Color.white)   // Or your card background
//                .cornerRadius(12)
//                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
//            }
//            //.buttonStyle(PlainButtonStyle())
//            .navigationDestination(for: Product.self) { product in
//                ProductDetailView(
//                    vm: ProductDetailViewModel(
//                        product: product,
//                        repository: UProductDetailsRepository(localizer: vm.langHandler),
//                        imgRepository: UImageRepository(),
//                        localizer: vm.langHandler
//                    ),
//                    cartViewModel: cartModelVM
//                )
//            }

//FIXME: This approach initializes ProductDetailViewModel for each visible list product items. Solution is to use UIKit navigation or try with iOS16+ NavigationLink(value: product), which doesn't work as expected.
            NavigationLink {
                ProductDetailView(vm: ProductDetailViewModel(
                    product: product,
                    repository: UProductDetailsRepository(localizer: vm.langHandler),
                    imgRepository: UImageRepository(),
                    localizer: vm.langHandler
                ), cartViewModel: cartModelVM)
            } label: {
                ProductCard(product: product,
                            imgRepository: UImageRepository(),
                            localizer: vm.langHandler,
                            cartViewModel: cartModelVM, onTap: { prd in
                    alertProductName = prd.name
                    showAddedToCart = true
                })
            }
            .buttonStyle(PlainButtonStyle())
            .alert(alertProductName, isPresented: $showAddedToCart) {
                Button(vm.langHandler.localized("ok")) {
                }
            } message: {
                Text(vm.langHandler.localized("product_added_successfully"))
            }

            }
        }
    }
    
    private var gridColumns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad: 3 columns for better use of space
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]
        } else {
            // iPhone: 2 columns
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]
        }
    }
}

#Preview {
    let localizer =  MockLocalizer(overrides: [
        "loading_categories": "",
        "products": "Products",
        "items_count": "Filtered count: 1",
        "retry": "Retry",
        "error": "Error",
        "loading_products": "Loading products..",
        "categories": "Categories",
        "no_products_available": "No products available",
        "search_products_placeholder": "Search products",
        "no_products_in_category": "No products in the category"
    ])

    let handler = LocalizationHandler(language: .english)
    let bannerItem = BannerItem.bannerDemoItem(localizer: localizer)
let cartModel = CartViewModel(localizer: localizer)
    StoreView(vm: StoreViewModel(repository: UStoreRepository(localizer: localizer),
                                 imgRepository: UImageRepository(),
                                 bannerItem: bannerItem,
                                 langHandler: handler), cartModelVM: cartModel)
}




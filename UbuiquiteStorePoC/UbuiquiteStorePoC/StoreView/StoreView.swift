//
//  StoreView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct StoreView: View {
    @ObservedObject private var viewModel: StoreViewModel
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingLanguageSwitcher = false
    @State private var showingLocalizationTest = false

    public init(vm: StoreViewModel) {
        self.viewModel = vm
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content area with gradient overlay
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Banner
                            BannerView(bannerItem: viewModel.bannerItem,
                                       storeURL: viewModel.storeURL)

                        // Categories
                        if viewModel.isLoadingCategories {
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text("loading_categories".localized)
                                    .font(.subheadline)
                                    .foregroundColor(Color(.secondaryLabel))
                                    .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                        } else if !viewModel.categories.isEmpty {
                            categoriesView
                        }
                        
                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 32))
                                    .foregroundColor(.orange)
                                
                                Text("error".localized)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("retry".localized) {
                                    Task {
                                        await viewModel.loadCategories()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Products
                        productsView
                    }
                        .padding(.horizontal, viewModel.horizontalPadding)
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
            await viewModel.loadCategories()
        }
        .sheet(isPresented: $showingLanguageSwitcher) {
            LanguageSwitcherView()
        }
        .sheet(isPresented: $showingLocalizationTest) {
            LocalizationTestView()
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
                        Text(localizationManager.currentLanguage.flag)
                            .font(.title3)
                        Text(localizationManager.currentLanguage.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Debug button - long press to show language info
                Button(action: {
                    print(localizationManager.getCurrentLanguageInfo())
                }) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .onLongPressGesture {
                    print(localizationManager.getCurrentLanguageInfo())
                }
                
                // Localization Test Button
                Button(action: {
                    showingLocalizationTest = true
                }) {
                    Image(systemName: "textformat.abc")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("search_products_placeholder".localized, text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
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
        .padding(.horizontal, viewModel.horizontalPadding)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private var categoriesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("categories".localized)
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(
                            category: category,
                            isSelected: viewModel.selectedCategory?.id == category.id
                        ) {
                            Task {
                                await viewModel.selectCategory(category)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var productsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("products".localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if !viewModel.products.isEmpty {
                    Text(String(format: "items_count".localized, viewModel.filteredProducts.count))
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            
            if viewModel.isLoadingProducts {
                loadingView
            } else if viewModel.filteredProducts.isEmpty {
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
            Text("loading_products".localized)
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
            
            Text("no_products_available".localized)
                .font(.headline)
                .fontWeight(.medium)
            
            Text("no_products_in_category".localized)
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(viewModel.filteredProducts) { product in
                //TODO: Check this! If this not initialized already Product Detaisl VM!!!
                NavigationLink(destination: ProductDetailView(vm: ProductDetailViewModel(product: product,
                                                                                         repository: UProductDetailsRepository(),
                                                                                         imgRepository: UImageRepository()))) {
                    ProductCard(product: product,
                                imageURL: viewModel.imageURL(imageName: product.imageUrl))
                }
                .buttonStyle(PlainButtonStyle())
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
    StoreView(vm: StoreViewModel(repository: UStoreRepository(),
                                 imgRepository: UImageRepository(),
                                 bannerItem: BannerItem.bannerDemoItem))
}




//
//  StoreView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = StoreViewModel()
    
    private var horizontalPadding: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 32 // More padding for iPad
        } else {
            return 16 // Standard padding for iPhone
        }
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
                            bannerView
                        
                        // Categories
                        if viewModel.isLoadingCategories {
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text("Loading categories...")
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
                                
                                Text("Error")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Retry") {
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
                    .padding(.horizontal, horizontalPadding)
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
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("UniFi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search products...", text: $viewModel.searchText)
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
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var bannerView: some View {
        Button(action: {
            if let url = URL(string: "https://store.ui.com/us/en") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Introducing")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("UniFi U7 Pro")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("WiFi 7 for high-performance networks")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Placeholder for U7 Pro image
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text("U7")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    )
            }
                    .padding(20)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        }
        .buttonStyle(BannerButtonStyle())
    }
    
    private var categoriesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
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
                Text("Products")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if !viewModel.products.isEmpty {
                                    Text("\(viewModel.filteredProducts.count) items")
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
                            Text("Loading products...")
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
            
            Text("No products available")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("This category doesn't have any products yet.")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(viewModel.filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCard(product: product)
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

struct CategoryCard: View {
    let category: ProductCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(category.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BannerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Partner Program Badge - positioned above product image
            if product.partnerProgram {
                HStack {
                    Image("PartnerProgram")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 30)
                    
                    Spacer()
                }
            }
            
            // Product Image
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API/store-pics/\(product.imageUrl)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                    )
            }
            .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120)
            .cornerRadius(8)
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "wifi")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(product.wifiStandard)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    if let frequency = product.frequency {
                        Text("• \(frequency)")
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                
                Spacer(minLength: 0)
                
                Text("€\(String(format: "%.2f", product.price))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .frame(height: 280) // Fixed height for all cards
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 4, x: 0, y: 2)
    }
}

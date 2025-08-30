//
//  StoreView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = StoreViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
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
                                    .foregroundColor(.secondary)
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
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.loadCategories()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
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
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var bannerView: some View {
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
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
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
                        .foregroundColor(.secondary)
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
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No products available")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("This category doesn't have any products yet.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(viewModel.filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCard(product: product)
                }
                .buttonStyle(PlainButtonStyle())
            }
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

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product Image with Partner Program Badge
            ZStack(alignment: .topTrailing) {
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
                .frame(height: 120)
                .cornerRadius(8)
                
                // Partner Program Badge
                if product.partnerProgram {
                    Image("PartnerProgram")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(4)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
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
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("€\(String(format: "%.2f", product.price))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

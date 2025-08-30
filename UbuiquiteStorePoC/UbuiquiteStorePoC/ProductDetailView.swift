//
//  ProductDetailView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel
    
    init(product: Product) {
        self._viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Product Image
                AsyncImage(url: viewModel.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                                .scaleEffect(1.2)
                        )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Product Title and Price
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.product.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("€\(String(format: "%.2f", viewModel.product.price))")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    // Product Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(viewModel.product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Specifications
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Specifications")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "wifi")
                                    .foregroundColor(.blue)
                                Text("WiFi Standard: \(viewModel.product.wifiStandard)")
                                    .font(.subheadline)
                            }
                            
                            if let frequency = viewModel.product.frequency {
                                HStack {
                                    Image(systemName: "waveform")
                                        .foregroundColor(.blue)
                                    Text("Frequency: \(frequency)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                    
                    // Loading indicator for additional details
                    VStack(spacing: 12) {
                        Divider()
                        
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Loading additional details...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

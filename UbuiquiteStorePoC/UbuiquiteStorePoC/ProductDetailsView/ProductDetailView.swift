//
//  ProductDetailView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct ProductDetailView: View {
    @ObservedObject private var vm: ProductDetailViewModel

    init(vm: ProductDetailViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Product Image with Partner Program Badge
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: vm.imageURL) { image in
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
                    .background(Color(.systemGray6))
                    
                    // Partner Program Badge
                    if vm.product.partnerProgram {
                        VStack(spacing: 0) {
                            Text("UniFi")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1)
                                .padding(.horizontal, 4)
                            Text(vm.localizer.localized("partner"))
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(vm.localizer.localized("program"))
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.black)
                        .cornerRadius(6)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .padding(16)
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Product Title and Price
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vm.product.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(String(format: vm.localizer.localized("euro_symbol") + "%.2f", vm.product.price))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    // Product Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vm.localizer.localized("description"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(vm.product.description)
                            .font(.body)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    
                    // Specifications
                    VStack(alignment: .leading, spacing: 8) {
                        Text(vm.localizer.localized("specifications"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "wifi")
                                    .foregroundColor(.blue)
                                Text(String(format: vm.localizer.localized("wifi_standard"), vm.product.wifiStandard))
                                    .font(.subheadline)
                            }
                            
                            if let frequency = vm.product.frequency {
                                HStack {
                                    Image(systemName: "waveform")
                                        .foregroundColor(.blue)
                                    Text(String(format: vm.localizer.localized("frequency"), frequency))
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                    
                    // Buy Section
                    VStack(alignment: .leading, spacing: 16) {
                        Divider()
                        
                        Text(vm.localizer.localized("purchase_options"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        // Quantity Stepper
                        HStack {
                            Text(vm.localizer.localized("quantity"))
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Button(action: vm.decrementQuantity) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                
                                Text("\(vm.quantity)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .frame(minWidth: 40)
                                    .padding(.horizontal, 8)
                                
                                Button(action: vm.incrementQuantity) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        // Add to Cart Button
                        Button(action: vm.addToCart) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                Text(vm.localizer.localized("add_to_cart"))
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    
                    // Additional Details Sections
                    if let details = vm.productDetails {
                        // Overview Section
                        VStack(alignment: .leading, spacing: 8) {
                                                    Text(vm.localizer.localized("overview"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            
                            Text(details.overview)
                                .font(.body)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        
                        // Features Section
                        VStack(alignment: .leading, spacing: 8) {
                                                    Text(vm.localizer.localized("features"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(details.features, id: \.self) { feature in
                                    HStack(alignment: .top) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.caption)
                                        Text(feature)
                                            .font(.subheadline)
                                            .foregroundColor(Color(.secondaryLabel))
                                    }
                                }
                            }
                        }
                        
                        // Hardware Section
                        VStack(alignment: .leading, spacing: 8) {
                                                    Text(vm.localizer.localized("hardware"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(details.hardware, id: \.property) { spec in
                                    HStack {
                                        Text(spec.property)
                                            .font(.subheadline)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .frame(width: 120, alignment: .leading)
                                        
                                        Text(spec.value)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        }
                        
                        // Software Section
                        VStack(alignment: .leading, spacing: 8) {
                                                    Text(vm.localizer.localized("software"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(details.software, id: \.property) { spec in
                                    HStack {
                                        Text(spec.property)
                                            .font(.subheadline)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .frame(width: 120, alignment: .leading)
                                        
                                        Text(spec.value)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        }
                    } else if vm.isLoadingDetails {
                        // Loading indicator for additional details
                        VStack(spacing: 12) {
                            Divider()
                            
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text(vm.localizer.localized("loading_additional_details"))
                                    .font(.subheadline)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle(vm.localizer.localized("product_details"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadProductDetails()
        }
    }
}

//
//  ProductDetailView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import SwiftUI

struct ProductDetailView: View {
    @ObservedObject private var vm: ProductDetailViewModel
    @ObservedObject private var cartViewModel: CartViewModel
    @State private var showAddedToCart: Bool = false
    @Environment(\.dismiss) private var dismiss

    init(vm: ProductDetailViewModel, cartViewModel: CartViewModel) {
        self.vm = vm
        self.cartViewModel = cartViewModel
        //print("INIT ProductDetailViewModel")
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

                    // Partner Program Badge - positioned above product image
                    if vm.product.partnerProgram {
                        HStack {
                            Image("PartnerProgram")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 60)

                            Spacer()
                        }.padding()
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {

                    // Product Title and Price
                    productTitleAndPrice
                    // Product Description
                    productDescription
                    //Specifications
                    specifications
                    // Buy Section
                    buySection

                    // Additional Details Sections
                    if let details = vm.productDetails {
                        // Features Section
                        let features = details.features

                        FeatureSectionView(title: vm.localizer.localized("features"),
                                           features: features?.wireless ?? [])
                        FeatureSectionView(title: vm.localizer.localized("portal_features"),
                                           features: features?.captivePortal ?? [])
                        FeatureSectionView(title: vm.localizer.localized("security"),
                                           features: features?.security ?? [])

                        // Software Section
                        softwareSection

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
        .navigationBarBackButtonHidden(true) // Hide default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(vm.localizer.localized("back"))
                    }
                }
            }
        }
    }

    private var productTitleAndPrice: some View {
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
    }

    private var productDescription: some View {
        // Product Description
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.localizer.localized("description"))
                .font(.headline)
                .fontWeight(.semibold)

            Text(vm.product.description)
                .font(.body)
                .foregroundColor(Color(.secondaryLabel))
        }
    }

    private var specifications: some View {
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
    }


    private var buySection: some View {
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
            Button(action: {
                cartViewModel.addToCart(product: vm.product, quantity: vm.quantity)
                showAddedToCart = true
            }) {
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
            .alert(vm.product.name, isPresented: $showAddedToCart) {
                Button(vm.localizer.localized("ok")) {
                }
            } message: {
                Text(vm.localizer.localized("product_added_successfully"))
            }
        }
    }

    private var softwareSection: some View {

        VStack(alignment: .leading, spacing: 8) {
            Text(vm.localizer.localized("software"))
                .font(.headline)

            let software = vm.productDetails?.software

            Text("\(vm.localizer.localized("ios")): \(software?.mobileApp?.ios ?? "")") .foregroundColor(.secondary)
            Text("\(vm.localizer.localized("android")): \(software?.mobileApp?.android ?? "")") .foregroundColor(.secondary)
            Text("\(vm.localizer.localized("unifi_network")): \(software?.unifiNetwork ?? "")") .foregroundColor(.secondary)

        }.padding(.vertical)
    }
}

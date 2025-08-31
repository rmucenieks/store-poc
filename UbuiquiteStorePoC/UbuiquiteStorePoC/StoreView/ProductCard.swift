//
//  ProductCardView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//
import SwiftUI

struct ProductCard: View {
    let vm: CartViewModel
    let product: Product
    let imageURL: URL?
    @State var showAddedToCart = false

    init(product: Product,
         imageURL: URL?,
         localizer: Localizer,
         cartViewModel: CartViewModel) {
        self.product = product
        self.imageURL = imageURL
        self.vm = cartViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Partner Program Badge - positioned above product image
            ZStack(alignment: .topLeading) {

                // Product Image
                AsyncImage(url: imageURL) { image in
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

                // Partner Program Badge - positioned above product image
                if product.partnerProgram {
                    HStack {
                        Image("PartnerProgram")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 30)

                        Spacer()
                    }//.padding()
                }
            }

//            if product.partnerProgram {
//                HStack {
//                    Image("PartnerProgram")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 60, height: 30)
//
//                    Spacer()
//                }
//            }

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
                        Text(String(format: vm.localizer.localized("frequency_separator"), frequency))
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }

                Spacer(minLength: 0)

                Text(String(format: vm.localizer.localized("euro_symbol") + "%.2f", product.price))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // Add to Cart Button
                Button(action: {
                    vm.addToCart(product: product)
                    showAddedToCart = true
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                            .font(.caption)
                        Text(vm.localizer.localized("add_to_cart"))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .alert(product.name, isPresented: $showAddedToCart) {
                    Button(vm.localizer.localized("ok")) {
                    }
                } message: {
                    Text(vm.localizer.localized("product_added_successfully"))
                }
            }
        }
        .frame(height: 280) // Increased height to accommodate cart button
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    let mock = MockLocalizer(overrides: [
        "frequency_separator": "",
        "euro_symbol": "eur",
        "add_to_cart": "Add to Cart"
    ])
    
    let cartVM = CartViewModel(localizer: mock)

    ProductCard(product: Product.productDemoItem,
                imageURL: URL(string: "https://raw.githubusercontent.com/rmucenieks/store-pics/e7.avif"),
                localizer: mock,
                cartViewModel: cartVM)
}


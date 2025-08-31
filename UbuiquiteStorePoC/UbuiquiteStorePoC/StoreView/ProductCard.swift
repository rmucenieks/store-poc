//
//  ProductCardView.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//
import SwiftUI

struct ProductCard: View {
    let product: Product
    let imageURL: URL?

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
                        Text(String(format: "frequency_separator".localized, frequency))
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }

                Spacer(minLength: 0)

                Text(String(format: "euro_symbol".localized + "%.2f", product.price))
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

#Preview {
    ProductCard(product: Product.productDemoItem,
                imageURL: URL(string: "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API/store-pics/e7.avif"))
}


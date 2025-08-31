//
//  CategoryCard.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//
import SwiftUI

struct CategoryCard: View {
    let category: ProductCategory
    let isSelected: Bool
    let onTap: () -> Void //TODO: Void should be optional!!!!

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

#Preview {
    CategoryCard(category: ProductCategory(id: "wifi",
                                           name: "Wifi",
                                           icon: "wifi",
                                           productsPath: "wifi-products.json"),
                 isSelected: true) {

    }
}


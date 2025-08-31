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
    let onTap: VoidFunc?

    var body: some View {
        Button(action:{
            onTap?()
        }) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                    .padding(.top, 4)

                Text(category.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        // Selected state
        CategoryCard(category: ProductCategory(id: "wifi",
                                               name: "WiFi",
                                               icon: "wifi",
                                               productsPath: "wifi-products.json"),
                     isSelected: true) {
        }
        
        // Unselected state with long text
        CategoryCard(category: ProductCategory(id: "camera-security",
                                               name: "Videonovērošana",
                                               icon: "camera.fill",
                                               productsPath: ""),
                     isSelected: false) {
        }
        
        // Another long text example
        CategoryCard(category: ProductCategory(id: "door-access",
                                               name: "Durvju piekļuve",
                                               icon: "lock.open.fill",
                                               productsPath: ""),
                     isSelected: false) {
        }
    }
    .padding()
}


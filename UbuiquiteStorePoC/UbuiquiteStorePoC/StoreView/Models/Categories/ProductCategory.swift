//
//  ProductCategory.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

struct ProductCategory: Identifiable, Decodable {
    let id: String
    let name: String
    let icon: String
    let productsPath: String?
}

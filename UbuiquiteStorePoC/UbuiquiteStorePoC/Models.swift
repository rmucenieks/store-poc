//
//  Models.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

struct CategoryList: Decodable {
    let categories: [Category]
}

struct ProductList: Decodable {
    let products: [Product]
}



struct Category: Identifiable, Decodable {
    let id: String
    let name: String
    let icon: String
    let products: String?
}

struct Product: Identifiable, Decodable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let wifiStandard: String
    let frequency: String?
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case wifiStandard
        case frequency
        case imageUrl
    }
}

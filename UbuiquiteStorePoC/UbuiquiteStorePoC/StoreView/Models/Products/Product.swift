//
//  Product.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

struct Product: Identifiable, Decodable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let wifiStandard: String
    let frequency: String?
    let imageUrl: String
    let partnerProgram: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case wifiStandard
        case frequency
        case imageUrl
        case partnerProgram
    }

    static var  productDemoItem: Product {
        return Product(id: "e7",
                       name: "E7",
                       price: 499.00,
                       description: "Enterprise-grade indoor/outdoor access point with WiFi 7 performance.",
                       wifiStandard: "WiFi 7",
                       frequency: "5GHz",
                       imageUrl: "e7.avif",
                       partnerProgram: true)
    }

}

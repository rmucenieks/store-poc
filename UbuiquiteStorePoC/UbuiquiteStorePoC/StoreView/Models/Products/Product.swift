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
}

//
//  ProductDetails.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

struct ProductDetails: Decodable {
    let overview: String
    let features: [String]
    let hardware: [HardwareSpec]
    let software: [SoftwareSpec]
}

struct HardwareSpec: Decodable {
    let property: String
    let value: String
}

struct SoftwareSpec: Decodable {
    let property: String
    let value: String
}

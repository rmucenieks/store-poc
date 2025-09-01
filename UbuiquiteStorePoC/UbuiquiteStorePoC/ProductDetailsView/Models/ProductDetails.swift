//
//  ProductDetails.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

struct ProductDetails: Decodable {
    let overview: OverViewSpec?
    let hardware: HardwareSpec?
    let software: SoftwareSpec?
    let features: FeaturesSpec?
}

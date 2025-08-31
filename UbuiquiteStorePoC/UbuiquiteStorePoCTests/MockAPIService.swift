//
//  MockAPIService.swift
//  UbuiquiteStorePoCTests
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation
@testable import UbuiquiteStorePoC

class MockAPIService: APIServiceProtocol {
    var categoriesResult: Result<[ProductCategory], Error> = .success([])
    var productsResult: Result<[Product], Error> = .success([])
    var productDetailsResult: Result<ProductDetails, Error> = .success(ProductDetails(
        overview: "Enterprise-grade WiFi 7 access point",
        features: ["WiFi 7", "10 GbE uplink", "Tri-radio"],
        hardware: [
            HardwareSpec(property: "Max. Power Consumption", value: "43W"),
            HardwareSpec(property: "Weight", value: "1.8 kg")
        ],
        software: [
            SoftwareSpec(property: "Management", value: "Ethernet"),
            SoftwareSpec(property: "Certifications", value: "CE, FCC, IC")
        ]
    ))
    var imageURL: URL?
    
    func fetchCategories() async -> Result<[ProductCategory], Error> {
        return categoriesResult
    }
    
    func fetchProducts(for category: ProductCategory) async -> Result<[Product], Error> {
        return productsResult
    }
    
    func fetchProductDetails(for productId: String) async -> Result<ProductDetails, Error> {
        return productDetailsResult
    }
    
    func getImageURL(for imageName: String) -> URL? {
        return imageURL
    }
}

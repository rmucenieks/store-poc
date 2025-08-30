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
    var imageURL: URL?
    
    func fetchCategories() async -> Result<[ProductCategory], Error> {
        return categoriesResult
    }
    
    func fetchProducts(for category: ProductCategory) async -> Result<[Product], Error> {
        return productsResult
    }
    
    func getImageURL(for imageName: String) -> URL? {
        return imageURL
    }
}

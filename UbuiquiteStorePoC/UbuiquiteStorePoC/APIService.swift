//
//  APIService.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

class APIService: APIServiceProtocol {
    private let baseURL = "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API"
    
    func fetchCategories() async -> Result<[ProductCategory], Error> {
        do {
            let url = URL(string: "\(baseURL)/categories.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let categoriesList = try JSONDecoder().decode(CategoryList.self, from: data)
            return .success(categoriesList.categories)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchProducts(for category: ProductCategory) async -> Result<[Product], Error> {
        guard let productsFileName = category.products, !productsFileName.isEmpty else {
            return .success([])
        }
        
        do {
            let url = URL(string: "\(baseURL)/\(productsFileName)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let productList = try JSONDecoder().decode(ProductList.self, from: data)
            return .success(productList.products)
        } catch {
            return .failure(error)
        }
    }
    
    func getImageURL(for imageName: String) -> URL? {
        return URL(string: "\(baseURL)/store-pics/\(imageName)")
    }
}

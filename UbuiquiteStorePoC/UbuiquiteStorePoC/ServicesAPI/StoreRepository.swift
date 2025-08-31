//
//  StoreRepository.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

internal protocol StoreRepository {
    func fetchCategories() async -> Result<[ProductCategory], Error>
    func fetchProducts(productsPath: String?) async -> Result<[Product], Error>
}

internal struct UStoreRepository: StoreRepository {
    let localizer: Localizer

    init(localizer: Localizer) {
        self.localizer = localizer
    }

    func fetchCategories() async -> Result<[ProductCategory], Error> {
        let url = URL(string: APIServiceConstants.baseURL)?
            .appending(path: localizer.currentLangKey)
            .appending(path: APIServiceConstants.categoriesJSON)
        
//        print("🌐 Fetching categories from: \(url?.absoluteString ?? "nil")")
//        print("🌐 Current language: \(localizer.currentLangKey)")
        
        guard let url = url else {
            print("❌ Failed to construct URL for categories")
            return .success([])
        }
        print("FETCH: URL: \(url)")

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let categoriesList = try JSONDecoder().decode(CategoryList.self, from: data)
            print("✅ Successfully loaded \(categoriesList.categories.count) categories for language: \(localizer.currentLangKey)")
            return .success(categoriesList.categories)
        } catch {
            print("❌ Failed to load categories: \(error)")
            return .failure(error)
        }
    }

    func fetchProducts(productsPath: String?) async -> Result<[Product], Error> {
        guard let productsFileName = productsPath, !productsFileName.isEmpty else {
            print("❌ No products path provided")
            return .success([])
        }

        let url = URL(string: APIServiceConstants.baseURL)?
            .appending(path: localizer.currentLangKey)
            .appending(path: productsFileName)

//        print("🌐 Fetching products from: \(url?.absoluteString ?? "nil")")
//        print("🌐 Products file: \(productsFileName)")
        
        guard let url = url else {
            print("❌ Failed to construct URL for products")
            return .success([])
        }

        print("FETCH: URL: \(url)")

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let productList = try JSONDecoder().decode(ProductList.self, from: data)
            print("✅ Successfully loaded \(productList.products.count) products for language: \(localizer.currentLangKey)")
            return .success(productList.products)
        } catch {
            print("❌ Failed to load products: \(error)")
            return .failure(error)
        }
    }
}

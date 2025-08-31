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

    func fetchCategories() async -> Result<[ProductCategory], Error> {
        guard let url = URL(string: APIServiceConstants.baseURL)?
            .appending(path: APIServiceConstants.categoriesJSON) else {
            return .success([])
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let categoriesList = try JSONDecoder().decode(CategoryList.self, from: data)
            return .success(categoriesList.categories)
        } catch {
            return .failure(error)
        }
    }

    func fetchProducts(productsPath: String?) async -> Result<[Product], Error> {
        guard let productsFileName = productsPath, !productsFileName.isEmpty,
                let url = URL(string: APIServiceConstants.baseURL)?.appending(path: productsFileName)
        else {
            return .success([])
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let productList = try JSONDecoder().decode(ProductList.self, from: data)
            return .success(productList.products)
        } catch {
            return .failure(error)
        }
    }
}

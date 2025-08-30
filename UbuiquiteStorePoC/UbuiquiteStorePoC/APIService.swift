//
//  APIService.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

class APIService: ObservableObject {
    private let baseURL = "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API"
    
    @Published var categories: [Category] = []
    @Published var products: [Product] = []
    @Published var isLoadingCategories = false
    @Published var isLoadingProducts = false
    @Published var errorMessage: String?
    
    func fetchCategories() async {
        await MainActor.run {
            isLoadingCategories = true
            errorMessage = nil
        }
        
        do {
            let url = URL(string: "\(baseURL)/categories.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let categoriesList = try JSONDecoder().decode(CategoryList.self, from: data)

            await MainActor.run {
                self.categories = categoriesList.categories
                isLoadingCategories = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load categories: \(error.localizedDescription)"
                isLoadingCategories = false
            }
        }
    }
    
    func fetchProducts(for category: Category) async {
        guard let productsFileName = category.products, !productsFileName.isEmpty else {
            await MainActor.run {
                self.products = []
                isLoadingProducts = false
            }
            return
        }
        
        await MainActor.run {
            isLoadingProducts = true
            errorMessage = nil
        }
        
        do {
            let url = URL(string: "\(baseURL)/\(productsFileName)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let productList = try JSONDecoder().decode(ProductList.self, from: data)

            await MainActor.run {
                self.products = productList.products
                isLoadingProducts = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load products: \(error.localizedDescription)"
                isLoadingProducts = false
            }
        }
    }
    
    func getImageURL(for imageName: String) -> URL? {
        return URL(string: "\(baseURL)/store-pics/\(imageName)")
    }
}

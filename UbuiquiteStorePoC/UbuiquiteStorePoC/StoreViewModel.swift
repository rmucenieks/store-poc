//
//  StoreViewModel.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

@MainActor
class StoreViewModel: StoreViewModelProtocol {
    private let apiService: APIServiceProtocol
    
    @Published var categories: [ProductCategory] = []
    @Published var products: [Product] = []
    @Published var isLoadingCategories = false
    @Published var isLoadingProducts = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ProductCategory?
    @Published var searchText = ""
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func loadCategories() async {
        isLoadingCategories = true
        errorMessage = nil
        
        let result = await apiService.fetchCategories()
        
        switch result {
        case .success(let categories):
            self.categories = categories
            if let firstCategory = categories.first {
                selectedCategory = firstCategory
                await loadProducts(for: firstCategory)
            }
        case .failure(let error):
            errorMessage = "Failed to load categories: \(error.localizedDescription)"
        }
        
        isLoadingCategories = false
    }
    
    func selectCategory(_ category: ProductCategory) async {
        selectedCategory = category
        await loadProducts(for: category)
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func loadProducts(for category: ProductCategory) async {
        isLoadingProducts = true
        errorMessage = nil
        
        let result = await apiService.fetchProducts(for: category)
        
        switch result {
        case .success(let products):
            self.products = products
        case .failure(let error):
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
        
        isLoadingProducts = false
    }
}

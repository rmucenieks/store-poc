//
//  StoreViewModel.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

@MainActor //TODO: what is this?
class StoreViewModel: ObservableObject {
    private let repository: StoreRepository
    private let imgRepository: ImageRepository //TODO: use it also in the store picture fetch

    @Published var categories: [ProductCategory] = []
    @Published var products: [Product] = []
    @Published var isLoadingCategories = false
    @Published var isLoadingProducts = false
    @Published var errorMessage: String?
    @Published var selectedCategory: ProductCategory? //TODO: move this to id and find a object every time!!! Dont store actual objects
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
    
    init(repository: StoreRepository, imgRepository: ImageRepository) {
        self.repository = repository
        self.imgRepository = imgRepository
    }
    
    func loadCategories() async {
        isLoadingCategories = true
        errorMessage = nil
        
        let result = await repository.fetchCategories()

        switch result {
        case .success(let categories):
            self.categories = categories
            if let firstCategory = categories.first {
                selectedCategory = firstCategory
                await loadProducts(productsPath: firstCategory.productsPath)
            }
        case .failure(let error):
            errorMessage = "Failed to load categories: \(error.localizedDescription)"
        }
        
        isLoadingCategories = false
    }
    
    func selectCategory(_ category: ProductCategory) async {
        selectedCategory = category
        await loadProducts(productsPath: category.productsPath)
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func loadProducts(productsPath: String?) async {
        isLoadingProducts = true
        errorMessage = nil
        
        let result = await repository.fetchProducts(productsPath: productsPath)

        switch result {
        case .success(let products):
            self.products = products
        case .failure(let error):
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
        
        isLoadingProducts = false
    }
}

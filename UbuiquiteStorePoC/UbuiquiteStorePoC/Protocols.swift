//
//  Protocols.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCategories() async -> Result<[ProductCategory], Error>
    func fetchProducts(for category: ProductCategory) async -> Result<[Product], Error>
    func getImageURL(for imageName: String) -> URL?
}

@MainActor
protocol StoreViewModelProtocol: ObservableObject {
    var categories: [ProductCategory] { get }
    var products: [Product] { get }
    var filteredProducts: [Product] { get }
    var isLoadingCategories: Bool { get }
    var isLoadingProducts: Bool { get }
    var errorMessage: String? { get }
    var selectedCategory: ProductCategory? { get set }
    var searchText: String { get set }
    
    func loadCategories() async
    func selectCategory(_ category: ProductCategory) async
    func clearError()
}

@MainActor
protocol ProductDetailViewModelProtocol: ObservableObject {
    var product: Product { get }
    var imageURL: URL? { get }
}

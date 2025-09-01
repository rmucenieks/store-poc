//
//  StoreViewModel.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation
import UIKit

@MainActor
class StoreViewModel: ObservableObject {
    private let repository: StoreRepository
    private let imgRepository: ImageRepository
    @Published var langHandler: LocalizationHandler

    @Published var categories: [ProductCategory] = []
    @Published var products: [Product] = []
    @Published var isLoadingCategories = false
    @Published var isLoadingProducts = false
    @Published var categoriesErrorMsg: String? = nil
    @Published var productsErrorMsg: String? = nil
    @Published var selectedCategoryId: String?
    @Published var searchText = ""
    @Published var bannerItem: BannerItem

    var storeURL: URL? { return URL(string: "https://store.ui.com/us/en") }

    var horizontalPadding: CGFloat {
        if isIPad {
            return 32 //More space for ipad
        } else {
            return 16 // Standard padding for iPhone
        }
    }

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
    
    init(repository: StoreRepository,
         imgRepository: ImageRepository,
         bannerItem: BannerItem,
         langHandler: LocalizationHandler) {
        self.repository = repository
        self.imgRepository = imgRepository
        self.langHandler = langHandler
        self.bannerItem = bannerItem

        // Listen for language changes to reload data
        NotificationCenter.default.addObserver(
            forName: .languageChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task {
                await self?.loadCategories()
                await self?.reloadBannerItem()
            }
        }
    }

    func reloadBannerItem() async {
        self.bannerItem = BannerItem.bannerDemoItem(localizer: langHandler)
    }

    func loadCategories() async {
        products = []
        isLoadingCategories = true
        categoriesErrorMsg = nil

        let result = await repository.fetchCategories()

        switch result {
        case .success(let categories):
            self.categories = categories
            if selectedCategoryId == nil {
                if let firstCategory = categories.first {
                    selectedCategoryId = firstCategory.id
                }
            }
            if let category = category(at: selectedCategoryId, categories: categories) {
                await loadProducts(productsPath: category.productsPath)
            }

            isLoadingCategories = false
        case .failure(let error):
            categoriesErrorMsg = langHandler.localized("failed_to_load_categories") + ": \(error.localizedDescription)"
            isLoadingCategories = false
        }
    }
    private func category(at id: String?, categories: [ProductCategory]) -> ProductCategory? {
        return categories.first(where: { $0.id == id })
    }

    func selectCategory(_ category: ProductCategory) async {
        selectedCategoryId = category.id
        await loadProducts(productsPath: category.productsPath)
    }
    
    internal func imageURL(imageName: String) -> URL? {
        imgRepository.getImageURL(for: imageName)
    }

    func clearError() {
        categoriesErrorMsg = nil
        productsErrorMsg = nil
    }
    
    private func loadProducts(productsPath: String?) async {
        isLoadingProducts = true
        productsErrorMsg = nil

        let result = await repository.fetchProducts(productsPath: productsPath)

        switch result {
        case .success(let products):
            self.products = products
        case .failure(let error):
            productsErrorMsg = langHandler.localized("failed_to_load_products") + ": \(error.localizedDescription)"
        }
        
        isLoadingProducts = false
    }
}

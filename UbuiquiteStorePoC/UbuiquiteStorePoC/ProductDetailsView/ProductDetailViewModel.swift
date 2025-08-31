//
//  ProductDetailViewModel.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

@MainActor
class ProductDetailViewModel: ObservableObject {
    private let repository: ProductDetailsRepository
    private let imgRepository: ImageRepository

    let product: Product
    @Published var productDetails: ProductDetails?
    @Published var isLoadingDetails = false
    @Published var quantity = 1
    
    var imageURL: URL? {
        imgRepository.getImageURL(for: product.imageUrl)
    }
    
    init(product: Product,
         repository: ProductDetailsRepository,
         imgRepository: ImageRepository) {
        self.product = product
        self.repository = repository
        self.imgRepository = imgRepository
    }
    
    func loadProductDetails() async {
        isLoadingDetails = true
        
        let result = await repository.fetchProductDetails(for: product.id)

        switch result {
        case .success(let details):
            self.productDetails = details
        case .failure(let error):
            print("Failed to load product details: \(error)")
        }
        
        isLoadingDetails = false
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    func addToCart() {
        // TODO: Implement add to cart functionality
        print("Adding \(quantity) \(product.name) to cart")
    }
}

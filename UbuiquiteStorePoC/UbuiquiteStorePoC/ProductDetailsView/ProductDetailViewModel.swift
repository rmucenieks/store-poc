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
    let localizer: Localizer
    @Published var productDetails: ProductDetails? = nil
    @Published var isLoadingDetails = false
    @Published var quantity = 1
    
    var imageURL: URL? {
        imgRepository.getImageURL(for: product.imageUrl)
    }
    
    init(product: Product,
         repository: ProductDetailsRepository,
         imgRepository: ImageRepository,
         localizer: Localizer) {
        self.product = product
        self.repository = repository
        self.localizer = localizer
        self.imgRepository = imgRepository
    }
    
    func loadProductDetails() async {
        isLoadingDetails = true
        self.productDetails = nil
        
        let result = await repository.fetchProductDetails(for: product.id)

        switch result {
        case .success(let details):
            self.productDetails = details
        case .failure(let error):
            print("Failed to load product details: \(error)")
            self.productDetails = nil
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
}

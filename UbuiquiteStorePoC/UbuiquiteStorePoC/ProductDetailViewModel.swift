//
//  ProductDetailViewModel.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import Foundation

@MainActor
class ProductDetailViewModel: ProductDetailViewModelProtocol {
    private let apiService: APIServiceProtocol
    
    let product: Product
    
    var imageURL: URL? {
        apiService.getImageURL(for: product.imageUrl)
    }
    
    init(product: Product, apiService: APIServiceProtocol = APIService()) {
        self.product = product
        self.apiService = apiService
    }
}

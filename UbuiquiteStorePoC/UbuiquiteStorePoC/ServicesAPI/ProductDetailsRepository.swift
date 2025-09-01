//
//  ProductDetailsRepository.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

internal protocol ProductDetailsRepository {
    func fetchProductDetails(for productId: String) async -> Result<ProductDetails?, Error>
}

internal struct UProductDetailsRepository: ProductDetailsRepository {
    let localizer: Localizer

    init(localizer: Localizer) {
        self.localizer = localizer
    }

    func fetchProductDetails(for productId: String) async -> Result<ProductDetails?, Error> {
        guard let url = URL(string: APIServiceConstants.baseURL)?
            .appending(path: localizer.currentLangKey)
            .appending(path: APIServiceConstants.wifiProductDetailsJSON) else {
            return .success(nil)
        }
        print("FETCH: URL: \(url)")

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let root = try JSONDecoder().decode(ProductDetailsRoot.self, from: data)
            return .success(root.product)
        } catch {
            return .failure(error)
        }
    }

}

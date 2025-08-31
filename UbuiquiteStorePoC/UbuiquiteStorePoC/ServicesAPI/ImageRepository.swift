//
//  ImageRepository.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

import Foundation

internal protocol ImageRepository {
    func getImageURL(for imageName: String) -> URL?
}

internal struct UImageRepository: ImageRepository {
    func getImageURL(for imageName: String) -> URL? {
        let url = URL(string: APIServiceConstants.baseURL)?
            .appending(path: APIServiceConstants.storePicsPath)
            .appending(path: imageName)
        return url
    }
}

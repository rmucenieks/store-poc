//
//  ImageRepository+Mock.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 01/09/2025.
//
import Foundation

internal struct MockImageRepository: ImageRepository {
    func getImageURL(for imageName: String) -> URL? {
        let url = URL(string: APIServiceConstants.localBaseURL)?
            .appending(path: APIServiceConstants.storePicsPath)
            .appending(path: imageName)
        return url
    }
}

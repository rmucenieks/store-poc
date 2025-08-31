//
//  APIServiceConstants.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//

class APIServiceConstants {
    // Use local files for localization testing
    internal static let useLocalFiles = true

    internal static let baseURL = useLocalFiles ? "file:///Users/rolandsmucenieks/Desktop/GIT/store-poc/API" : "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API"
    internal static let categoriesJSON = "categories.json"
    internal static let wifiProductDetailsJSON = "wifi-product-details.json"
    internal static let storePicsPath = "store-pics"
}

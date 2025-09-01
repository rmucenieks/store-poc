//
//  APIServiceConstants.swift
//  UbuiquiteStorePoC
//
//  Created by Rolands Mucenieks on 31/08/2025.
//
import UIKit

class APIServiceConstants {
    // Use local files for localization testing
    internal static let useLocalFiles = false

    internal static var baseURL: String {
        if useLocalFiles {
            return localBaseURL
        } else {
            return "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API"
        }
    }

    internal static var localBaseURL: String {
        if let path = Bundle.main.resourceURL?.appendingPathComponent("API").absoluteString {
            return path
        } else {
            return ""
        }
    }

    internal static let categoriesJSON = "categories.json"
    internal static let wifiProductDetailsJSON = "wifi-product-details.json"
    internal static let storePicsPath = "store-pics"
}

//
//  ModelsTests.swift
//  UbuiquiteStorePoCTests
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import XCTest
@testable import UbuiquiteStorePoC

final class ModelsTests: XCTestCase {
    
    func testCategoryDecoding() throws {
        // Given
        let json = """
        {
            "id": "wifi",
            "name": "WiFi",
            "icon": "wifi",
            "products": "wifi-products.json"
        }
        """.data(using: .utf8)!
        
        // When
        let category = try JSONDecoder().decode(ProductCategory.self, from: json)
        
        // Then
        XCTAssertEqual(category.id, "wifi")
        XCTAssertEqual(category.name, "wifi".localized)
        XCTAssertEqual(category.icon, "wifi")
        XCTAssertEqual(category.products, "wifi-products.json")
    }
    
    func testCategoryDecodingWithNilProducts() throws {
        // Given
        let json = """
        {
            "id": "switches",
            "name": "Switches",
            "icon": "network",
            "products": null
        }
        """.data(using: .utf8)!
        
        // When
        let category = try JSONDecoder().decode(ProductCategory.self, from: json)
        
        // Then
        XCTAssertEqual(category.id, "switches")
        XCTAssertEqual(category.name, "switches".localized)
        XCTAssertEqual(category.icon, "network")
        XCTAssertNil(category.products)
    }
    
    func testProductDecoding() throws {
        // Given
        let json = """
        {
            "id": "u7-pro",
            "name": "UniFi U7 Pro",
            "price": 199.99,
            "description": "WiFi 7 Access Point",
            "wifiStandard": "WiFi 7",
            "frequency": "6 GHz",
            "imageUrl": "u7-pro.avif",
            "partnerProgram": true
        }
        """.data(using: .utf8)!
        
        // When
        let product = try JSONDecoder().decode(Product.self, from: json)
        
        // Then
        XCTAssertEqual(product.id, "u7-pro")
        XCTAssertEqual(product.name, "UniFi U7 Pro")
        XCTAssertEqual(product.price, 199.99)
        XCTAssertEqual(product.description, "WiFi 7 Access Point")
        XCTAssertEqual(product.wifiStandard, "WiFi 7")
        XCTAssertEqual(product.frequency, "6 GHz")
        XCTAssertEqual(product.imageUrl, "u7-pro.avif")
        XCTAssertTrue(product.partnerProgram)
    }
    
    func testProductDecodingWithNilFrequency() throws {
        // Given
        let json = """
        {
            "id": "u6-pro",
            "name": "UniFi U6 Pro",
            "price": 179.99,
            "description": "WiFi 6 Access Point",
            "wifiStandard": "WiFi 6",
            "frequency": null,
            "imageUrl": "u6-pro.avif",
            "partnerProgram": false
        }
        """.data(using: .utf8)!
        
        // When
        let product = try JSONDecoder().decode(Product.self, from: json)
        
        // Then
        XCTAssertEqual(product.id, "u6-pro")
        XCTAssertEqual(product.name, "UniFi U6 Pro")
        XCTAssertEqual(product.price, 179.99)
        XCTAssertEqual(product.description, "WiFi 6 Access Point")
        XCTAssertEqual(product.wifiStandard, "WiFi 6")
        XCTAssertNil(product.frequency)
        XCTAssertEqual(product.imageUrl, "u6-pro.avif")
        XCTAssertFalse(product.partnerProgram)
    }
    
    func testCategoryListDecoding() throws {
        // Given
        let json = """
        {
            "categories": [
                {
                    "id": "wifi",
                    "name": "WiFi",
                    "icon": "wifi",
                    "products": "wifi-products.json"
                },
                {
                    "id": "switches",
                    "name": "Switches",
                    "icon": "network",
                    "products": null
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let categoryList = try JSONDecoder().decode(CategoryList.self, from: json)
        
        // Then
        XCTAssertEqual(categoryList.categories.count, 2)
        XCTAssertEqual(categoryList.categories[0].id, "wifi")
        XCTAssertEqual(categoryList.categories[1].id, "switches")
    }
    
    func testProductListDecoding() throws {
        // Given
        let json = """
        {
            "products": [
                {
                    "id": "u7-pro",
                    "name": "UniFi U7 Pro",
                    "price": 199.99,
                    "description": "WiFi 7 Access Point",
                    "wifiStandard": "WiFi 7",
                    "frequency": "6 GHz",
                    "imageUrl": "u7-pro.avif",
                    "partnerProgram": true
                },
                {
                    "id": "u6-pro",
                    "name": "UniFi U6 Pro",
                    "price": 179.99,
                    "description": "WiFi 6 Access Point",
                    "wifiStandard": "WiFi 6",
                    "frequency": null,
                    "imageUrl": "u6-pro.avif",
                    "partnerProgram": false
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let productList = try JSONDecoder().decode(ProductList.self, from: json)
        
        // Then
        XCTAssertEqual(productList.products.count, 2)
        XCTAssertEqual(productList.products[0].id, "u7-pro")
        XCTAssertEqual(productList.products[1].id, "u6-pro")
    }
}

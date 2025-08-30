//
//  StoreViewModelTests.swift
//  UbuiquiteStorePoCTests
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import XCTest
@testable import UbuiquiteStorePoC

@MainActor
final class StoreViewModelTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var viewModel: StoreViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = StoreViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadCategoriesSuccess() async {
        // Given
        let mockCategories = [
            ProductCategory(id: "1", name: "WiFi", icon: "wifi", products: "wifi-products.json"),
            ProductCategory(id: "2", name: "Switches", icon: "network", products: nil)
        ]
        mockAPIService.categoriesResult = .success(mockCategories)
        
        // When
        await viewModel.loadCategories()
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 2)
        XCTAssertEqual(viewModel.selectedCategory?.id, "1")
        XCTAssertFalse(viewModel.isLoadingCategories)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadCategoriesFailure() async {
        // Given
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        mockAPIService.categoriesResult = .failure(error)
        
        // When
        await viewModel.loadCategories()
        
        // Then
        XCTAssertTrue(viewModel.categories.isEmpty)
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertFalse(viewModel.isLoadingCategories)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage!.contains("Failed to load categories"))
    }
    
    func testSelectCategorySuccess() async {
        // Given
        let category = ProductCategory(id: "1", name: "WiFi", icon: "wifi", products: "wifi-products.json")
        let mockProducts = [
            Product(id: "1", name: "U7 Pro", price: 199.99, description: "WiFi 7 AP", wifiStandard: "WiFi 7", frequency: "6 GHz", imageUrl: "u7-pro.avif", partnerProgram: true)
        ]
        mockAPIService.productsResult = .success(mockProducts)
        
        // When
        await viewModel.selectCategory(category)
        
        // Then
        XCTAssertEqual(viewModel.selectedCategory?.id, "1")
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertFalse(viewModel.isLoadingProducts)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSelectCategoryFailure() async {
        // Given
        let category = ProductCategory(id: "1", name: "WiFi", icon: "wifi", products: "wifi-products.json")
        let error = NSError(domain: "Test", code: 1, userInfo: nil)
        mockAPIService.productsResult = .failure(error)
        
        // When
        await viewModel.selectCategory(category)
        
        // Then
        XCTAssertEqual(viewModel.selectedCategory?.id, "1")
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertFalse(viewModel.isLoadingProducts)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage!.contains("Failed to load products"))
    }
    
    func testSelectCategoryWithEmptyProducts() async {
        // Given
        let category = ProductCategory(id: "1", name: "WiFi", icon: "wifi", products: nil)
        
        // When
        await viewModel.selectCategory(category)
        
        // Then
        XCTAssertEqual(viewModel.selectedCategory?.id, "1")
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertFalse(viewModel.isLoadingProducts)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFilteredProductsWithSearch() {
        // Given
        let products = [
            Product(id: "1", name: "U7 Pro", price: 199.99, description: "WiFi 7 AP", wifiStandard: "WiFi 7", frequency: "6 GHz", imageUrl: "u7-pro.avif", partnerProgram: true),
            Product(id: "2", name: "U6 Pro", price: 179.99, description: "WiFi 6 AP", wifiStandard: "WiFi 6", frequency: "5 GHz", imageUrl: "u6-pro.avif", partnerProgram: false)
        ]
        viewModel.products = products
        
        // When
        viewModel.searchText = "U7"
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
        XCTAssertEqual(viewModel.filteredProducts.first?.name, "U7 Pro")
    }
    
    func testFilteredProductsWithEmptySearch() {
        // Given
        let products = [
            Product(id: "1", name: "U7 Pro", price: 199.99, description: "WiFi 7 AP", wifiStandard: "WiFi 7", frequency: "6 GHz", imageUrl: "u7-pro.avif", partnerProgram: true),
            Product(id: "2", name: "U6 Pro", price: 179.99, description: "WiFi 6 AP", wifiStandard: "WiFi 6", frequency: "5 GHz", imageUrl: "u6-pro.avif", partnerProgram: false)
        ]
        viewModel.products = products
        
        // When
        viewModel.searchText = ""
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 2)
    }
    
    func testFilteredProductsWithDescriptionSearch() {
        // Given
        let products = [
            Product(id: "1", name: "U7 Pro", price: 199.99, description: "WiFi 7 AP", wifiStandard: "WiFi 7", frequency: "6 GHz", imageUrl: "u7-pro.avif", partnerProgram: true),
            Product(id: "2", name: "U6 Pro", price: 179.99, description: "WiFi 6 AP", wifiStandard: "WiFi 6", frequency: "5 GHz", imageUrl: "u6-pro.avif", partnerProgram: false)
        ]
        viewModel.products = products
        
        // When
        viewModel.searchText = "WiFi 6"
        
        // Then
        XCTAssertEqual(viewModel.filteredProducts.count, 1)
        XCTAssertEqual(viewModel.filteredProducts.first?.name, "U6 Pro")
    }
    
    func testClearError() {
        // Given
        viewModel.errorMessage = "Test error"
        
        // When
        viewModel.clearError()
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
    }
}

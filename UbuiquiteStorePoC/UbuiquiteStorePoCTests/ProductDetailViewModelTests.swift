//
//  ProductDetailViewModelTests.swift
//  UbuiquiteStorePoCTests
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import XCTest
@testable import UbuiquiteStorePoC

@MainActor
final class ProductDetailViewModelTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var product: Product!
    var viewModel: ProductDetailViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        product = Product(
            id: "1",
            name: "U7 Pro",
            price: 199.99,
            description: "WiFi 7 AP",
            wifiStandard: "WiFi 7",
            frequency: "6 GHz",
            imageUrl: "u7-pro.avif",
            partnerProgram: true
        )
        viewModel = ProductDetailViewModel(product: product, apiService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        product = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testProductProperty() {
        // Then
        XCTAssertEqual(viewModel.product.id, "1")
        XCTAssertEqual(viewModel.product.name, "U7 Pro")
        XCTAssertEqual(viewModel.product.price, 199.99)
        XCTAssertEqual(viewModel.product.description, "WiFi 7 AP")
        XCTAssertEqual(viewModel.product.wifiStandard, "WiFi 7")
        XCTAssertEqual(viewModel.product.frequency, "6 GHz")
        XCTAssertEqual(viewModel.product.imageUrl, "u7-pro.avif")
        XCTAssertTrue(viewModel.product.partnerProgram)
    }
    
    func testImageURLWithValidImageName() {
        // Given
        let expectedURL = URL(string: "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API/store-pics/u7-pro.avif")
        mockAPIService.imageURL = expectedURL
        
        // Then
        XCTAssertEqual(viewModel.imageURL, expectedURL)
    }
    
    func testImageURLWithNilFromService() {
        // Given
        mockAPIService.imageURL = nil
        
        // Then
        XCTAssertNil(viewModel.imageURL)
    }
    
    func testLoadProductDetailsSuccess() async {
        // When
        await viewModel.loadProductDetails()
        
        // Then
        XCTAssertNotNil(viewModel.productDetails)
        XCTAssertFalse(viewModel.isLoadingDetails)
        XCTAssertEqual(viewModel.productDetails?.overview, "Enterprise-grade WiFi 7 access point")
        XCTAssertEqual(viewModel.productDetails?.features.count, 3)
        XCTAssertEqual(viewModel.productDetails?.hardware.count, 2)
        XCTAssertEqual(viewModel.productDetails?.software.count, 2)
    }
    
    func testQuantityStepper() {
        // Given
        let initialQuantity = viewModel.quantity
        
        // When
        viewModel.incrementQuantity()
        
        // Then
        XCTAssertEqual(viewModel.quantity, initialQuantity + 1)
        
        // When
        viewModel.decrementQuantity()
        
        // Then
        XCTAssertEqual(viewModel.quantity, initialQuantity)
        
        // Test minimum quantity
        viewModel.quantity = 1
        viewModel.decrementQuantity()
        XCTAssertEqual(viewModel.quantity, 1) // Should not go below 1
    }
    
    func testAddToCart() {
        // When
        viewModel.addToCart()
        
        // Then
        // This is a placeholder test since addToCart currently just prints
        // In a real app, you'd test the actual cart functionality
        XCTAssertTrue(true)
    }
}

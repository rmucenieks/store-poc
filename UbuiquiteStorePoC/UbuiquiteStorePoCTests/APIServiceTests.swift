//
//  APIServiceTests.swift
//  UbuiquiteStorePoCTests
//
//  Created by Rolands Mucenieks on 30/08/2025.
//

import XCTest
@testable import UbuiquiteStorePoC

final class APIServiceTests: XCTestCase {
    var apiService: APIService!
    
    override func setUp() {
        super.setUp()
        apiService = APIService()
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testGetImageURLWithValidImageName() {
        // Given
        let imageName = "u7-pro.avif"
        
        // When
        let url = apiService.getImageURL(for: imageName)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API/store-pics/u7-pro.avif")
    }
    
    func testGetImageURLWithEmptyImageName() {
        // Given
        let imageName = ""
        
        // When
        let url = apiService.getImageURL(for: imageName)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API/store-pics/")
    }
    
    func testGetImageURLWithSpecialCharacters() {
        // Given
        let imageName = "test-image@2x.png"
        
        // When
        let url = apiService.getImageURL(for: imageName)
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://raw.githubusercontent.com/rmucenieks/store-poc/main/API/store-pics/test-image@2x.png")
    }
}

import XCTest
@testable import UbuiquiteStorePoC

final class UbuiquiteStorePoCTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Basic Model Tests
    
    func testProductInitialization() throws {
        let product = Product(
            id: "test-product",
            name: "Test Product",
            price: 99.99,
            description: "Test Description",
            wifiStandard: "WiFi 6",
            frequency: "5 GHz",
            imageUrl: "test.avif",
            partnerProgram: true
        )
        
        XCTAssertEqual(product.id, "test-product")
        XCTAssertEqual(product.name, "Test Product")
        XCTAssertEqual(product.price, 99.99)
        XCTAssertEqual(product.description, "Test Description")
        XCTAssertEqual(product.wifiStandard, "WiFi 6")
        XCTAssertEqual(product.frequency, "5 GHz")
        XCTAssertEqual(product.imageUrl, "test.avif")
        XCTAssertTrue(product.partnerProgram)
    }
    
    func testProductCategoryInitialization() throws {
        let category = ProductCategory(
            id: "test-id",
            name: "Test Category",
            icon: "test-icon",
            productsPath: "test-path"
        )
        
        XCTAssertEqual(category.id, "test-id")
        XCTAssertEqual(category.name, "Test Category")
        XCTAssertEqual(category.icon, "test-icon")
        XCTAssertEqual(category.productsPath, "test-path")
    }
    
    func testCartItemInitialization() throws {
        let product = Product.productDemoItem
        let cartItem = CartItem(product: product, quantity: 3)
        
        XCTAssertEqual(cartItem.product.id, product.id)
        XCTAssertEqual(cartItem.quantity, 3)
        XCTAssertEqual(cartItem.totalPrice, product.price * 3)
    }
    
    func testCartItemTotalPrice() throws {
        let product = Product.productDemoItem
        let cartItem = CartItem(product: product, quantity: 5)
        
        let expectedTotal = product.price * 5
        XCTAssertEqual(cartItem.totalPrice, expectedTotal)
    }
    
    // MARK: - Localization Tests
    
    func testLocalizationHandlerInitialization() throws {
        let handler = LocalizationHandler()
        
        XCTAssertEqual(handler.currentLanguage, .english)
        XCTAssertEqual(handler.currentLangKey, "en")
        XCTAssertEqual(handler.allAppLanguages.count, 3)
    }
    
    func testLocalizationHandlerLanguageSwitching() throws {
        let handler = LocalizationHandler()
        
        // Test switching to Latvian
        handler.currentLanguage = .latvian
        XCTAssertEqual(handler.currentLanguage, .latvian)
        XCTAssertEqual(handler.currentLangKey, "lv")
        
        // Test switching to Russian
        handler.currentLanguage = .russian
        XCTAssertEqual(handler.currentLanguage, .russian)
        XCTAssertEqual(handler.currentLangKey, "ru")
        
        // Test switching back to English
        handler.currentLanguage = .english
        XCTAssertEqual(handler.currentLanguage, .english)
        XCTAssertEqual(handler.currentLangKey, "en")
    }
    
    // MARK: - Banner Item Tests
    
    func testBannerItemInitialization() throws {
        let mockLocalizer = MockLocalizer()
        let bannerItem = BannerItem.bannerDemoItem(localizer: mockLocalizer)
        
        XCTAssertNotNil(bannerItem)
        XCTAssertEqual(bannerItem.name, "UniFi")
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceExample() throws {
        measure {
            // Put the code you want to measure the time of here.
            let handler = LocalizationHandler()
            _ = handler.currentLanguage
            _ = handler.currentLangKey
        }
    }
}

// MARK: - Mock Localizer for Testing

class MockLocalizer: Localizer {
    var currentLangKey: String = "en"
    var currentLanguage: LocalizationHandler.Language = .english
    
    func localized(_ key: String) -> String {
        return key
    }
    
    func getCurrentLanguageInfo() -> String {
        return "Mock Localizer - English"
    }
    
    func resetToDefaultLanguage() {
        currentLanguage = .english
        currentLangKey = "en"
    }
    
    var allAppLanguages: [LocalizationHandler.Language] {
        return [.english, .latvian, .russian]
    }
}

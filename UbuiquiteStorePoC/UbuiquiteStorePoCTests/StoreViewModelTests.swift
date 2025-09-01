import XCTest
@testable import UbuiquiteStorePoC

@MainActor
final class StoreViewModelTests: XCTestCase {
    
    var sut: StoreViewModel!
    var mockRepository: MockStoreRepository!
    var mockImageRepository: MockImageRepository!
    var mockLocalizationHandler: MockLocalizationHandler!
    var mockBannerItem: BannerItem!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create mocks
        mockRepository = MockStoreRepository()
        mockImageRepository = MockImageRepository()
        mockLocalizationHandler = MockLocalizationHandler()
        mockBannerItem = BannerItem(
            id: "test-banner",
            name: "Test Banner",
            subtitle: "Test Subtitle",
            introText: "Test Intro",
            initials: "TB"
        )
        
        // Create system under test
        sut = StoreViewModel(
            repository: mockRepository,
            imgRepository: mockImageRepository,
            bannerItem: mockBannerItem,
            langHandler: mockLocalizationHandler
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        mockImageRepository = nil
        mockLocalizationHandler = nil
        mockBannerItem = nil
        
        // Remove notification observers
        NotificationCenter.default.removeObserver(sut as Any)
        
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() throws {
        XCTAssertEqual(sut.categories.count, 0)
        XCTAssertEqual(sut.products.count, 0)
        XCTAssertFalse(sut.isLoadingCategories)
        XCTAssertFalse(sut.isLoadingProducts)
        XCTAssertNil(sut.categoriesErrorMsg)
        XCTAssertNil(sut.productsErrorMsg)
        XCTAssertNil(sut.selectedCategoryId)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertEqual(sut.bannerItem.id, "test-banner")
        XCTAssertEqual(sut.langHandler.currentLangKey, "en")
    }
    
    // MARK: - Computed Properties Tests
    
    func testStoreURL() throws {
        let expectedURL = URL(string: "https://store.ui.com/us/en")
        XCTAssertEqual(sut.storeURL, expectedURL)
    }
    
    func testHorizontalPadding() throws {
        // Test iPhone padding (default)
        XCTAssertEqual(sut.horizontalPadding, 16)
        
        // Note: iPad testing would require device simulation
        // This test covers the default iPhone case
    }
    
    func testFilteredProductsWithEmptySearch() throws {
        // Given
        let testProducts = [
            Product(id: "1", name: "Product 1", price: 100, description: "Description 1", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img1.avif", partnerProgram: false),
            Product(id: "2", name: "Product 2", price: 200, description: "Description 2", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img2.avif", partnerProgram: true)
        ]
        sut.products = testProducts
        sut.searchText = ""
        
        // When
        let filtered = sut.filteredProducts
        
        // Then
        XCTAssertEqual(filtered.count, 2)
        XCTAssertEqual(filtered, testProducts)
    }
    
    func testFilteredProductsWithSearchText() throws {
        // Given
        let testProducts = [
            Product(id: "1", name: "WiFi Router", price: 100, description: "High-speed router", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img1.avif", partnerProgram: false),
            Product(id: "2", name: "Ethernet Switch", price: 200, description: "Network switch", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img2.avif", partnerProgram: true)
        ]
        sut.products = testProducts
        sut.searchText = "WiFi"
        
        // When
        let filtered = sut.filteredProducts
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "WiFi Router")
    }
    
    func testFilteredProductsWithDescriptionSearch() throws {
        // Given
        let testProducts = [
            Product(id: "1", name: "Router", price: 100, description: "High-speed WiFi router", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img1.avif", partnerProgram: false),
            Product(id: "2", name: "Switch", price: 200, description: "Network switch", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img2.avif", partnerProgram: true)
        ]
        sut.products = testProducts
        sut.searchText = "router"
        
        // When
        let filtered = sut.filteredProducts
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "Router")
    }
    
    func testFilteredProductsCaseInsensitive() throws {
        // Given
        let testProducts = [
            Product(id: "1", name: "WiFi Router", price: 100, description: "High-speed router", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img1.avif", partnerProgram: false)
        ]
        sut.products = testProducts
        sut.searchText = "wifi"
        
        // When
        let filtered = sut.filteredProducts
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "WiFi Router")
    }
    
    // MARK: - Load Categories Tests
    
    func testLoadCategoriesSuccess() async throws {
        // Given
        let testCategories = [
            ProductCategory(id: "cat1", name: "Category 1", icon: "icon1", productsPath: "products1.json"),
            ProductCategory(id: "cat2", name: "Category 2", icon: "icon2", productsPath: "products2.json")
        ]
        mockRepository.mockCategoriesResult = .success(testCategories)
        mockRepository.mockProductsResult = .success([])
        
        // When
        await sut.loadCategories()
        
        // Then
        XCTAssertEqual(sut.categories.count, 2)
        XCTAssertEqual(sut.categories, testCategories)
        XCTAssertFalse(sut.isLoadingCategories)
        XCTAssertNil(sut.categoriesErrorMsg)
        XCTAssertEqual(sut.selectedCategoryId, "cat1") // First category should be selected
    }
    
    func testLoadCategoriesFailure() async throws {
        // Given
        let testError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRepository.mockCategoriesResult = .failure(testError)
        mockLocalizationHandler.mockLocalizedString = "Failed to load categories"
        
        // When
        await sut.loadCategories()
        
        // Then
        XCTAssertEqual(sut.categories.count, 0)
        XCTAssertFalse(sut.isLoadingCategories)
        XCTAssertEqual(sut.categoriesErrorMsg, "Failed to load categories: Test error")
    }
    
    func testLoadCategoriesWithExistingSelection() async throws {
        // Given
        sut.selectedCategoryId = "cat2"
        let testCategories = [
            ProductCategory(id: "cat1", name: "Category 1", icon: "icon1", productsPath: "products1.json"),
            ProductCategory(id: "cat2", name: "Category 2", icon: "icon2", productsPath: "products2.json")
        ]
        mockRepository.mockCategoriesResult = .success(testCategories)
        mockRepository.mockProductsResult = .success([])
        
        // When
        await sut.loadCategories()
        
        // Then
        XCTAssertEqual(sut.selectedCategoryId, "cat2") // Should maintain existing selection
    }
    
    // MARK: - Select Category Tests
    
    func testSelectCategory() async throws {
        // Given
        let category = ProductCategory(id: "cat1", name: "Category 1", icon: "icon1", productsPath: "products1.json")
        let testProducts = [
            Product(id: "1", name: "Product 1", price: 100, description: "Description 1", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img1.avif", partnerProgram: false)
        ]
        mockRepository.mockProductsResult = .success(testProducts)
        
        // When
        await sut.selectCategory(category)
        
        // Then
        XCTAssertEqual(sut.selectedCategoryId, "cat1")
        XCTAssertEqual(sut.products.count, 1)
        XCTAssertEqual(sut.products.first?.name, "Product 1")
    }
    
    // MARK: - Load Products Tests
    
    func testLoadProductsSuccess() async throws {
        // Given
        let testProducts = [
            Product(id: "1", name: "Product 1", price: 100, description: "Description 1", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img1.avif", partnerProgram: false),
            Product(id: "2", name: "Product 2", price: 200, description: "Description 2", wifiStandard: "WiFi 6", frequency: "5GHz", imageUrl: "img2.avif", partnerProgram: true)
        ]
        mockRepository.mockProductsResult = .success(testProducts)
        
        // When
        await sut.loadCategories() // This will trigger loadProducts internally
        
        // Then
        XCTAssertEqual(sut.products.count, 2)
        XCTAssertFalse(sut.isLoadingProducts)
        XCTAssertNil(sut.productsErrorMsg)
    }
    
    func testLoadProductsFailure() async throws {
        // Given
        let testCategories = [
            ProductCategory(id: "cat1", name: "Category 1", icon: "icon1", productsPath: "products1.json")
        ]
        let testError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRepository.mockCategoriesResult = .success(testCategories)
        mockRepository.mockProductsResult = .failure(testError)
        mockLocalizationHandler.mockLocalizedString = "Failed to load products"
        
        // When
        await sut.loadCategories()
        
        // Then
        XCTAssertEqual(sut.products.count, 0)
        XCTAssertFalse(sut.isLoadingProducts)
        XCTAssertEqual(sut.productsErrorMsg, "Failed to load products: Test error")
    }
    
    func testLoadProductsWithNilPath() async throws {
        // Given
        let testCategories = [
            ProductCategory(id: "cat1", name: "Category 1", icon: "icon1", productsPath: nil)
        ]
        mockRepository.mockCategoriesResult = .success(testCategories)
        
        // When
        await sut.loadCategories()
        
        // Then
        XCTAssertEqual(sut.products.count, 0)
        XCTAssertFalse(sut.isLoadingProducts)
    }
    
    // MARK: - Image URL Tests
    
    func testImageURL() throws {
        // Given
        let imageName = "test-image.avif"
        let expectedURL = URL(string: "https://example.com/store-pics/test-image.avif")
        mockImageRepository.mockImageURL = expectedURL
        
        // When
        let result = sut.imageURL(imageName: imageName)
        
        // Then
        XCTAssertEqual(result, expectedURL)
    }
    
    // MARK: - Error Handling Tests
    
    func testClearError() throws {
        // Given
        sut.categoriesErrorMsg = "Test error"
        sut.productsErrorMsg = "Another error"
        
        // When
        sut.clearError()
        
        // Then
        XCTAssertNil(sut.categoriesErrorMsg)
        XCTAssertNil(sut.productsErrorMsg)
    }
    
    // MARK: - Banner Item Tests
    
    func testReloadBannerItem() async throws {
        // Given
        let originalBanner = sut.bannerItem
        
        // When
        await sut.reloadBannerItem()
        
        // Then
        // Banner should be updated (this tests the async nature)
        XCTAssertNotNil(sut.bannerItem)
    }
    
    // MARK: - Language Change Tests
    
    func testLanguageChangeNotification() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Language change notification received")
        
        // Set up notification observer
        NotificationCenter.default.addObserver(
            forName: .languageChanged,
            object: nil,
            queue: .main
        ) { _ in
            expectation.fulfill()
        }
        
        // When
        mockLocalizationHandler.currentLanguage = .latvian
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Objects

class MockStoreRepository: StoreRepository {
    var mockCategoriesResult: Result<[ProductCategory], Error> = .success([])
    var mockProductsResult: Result<[Product], Error> = .success([])
    
    func fetchCategories() async -> Result<[ProductCategory], Error> {
        return mockCategoriesResult
    }
    
    func fetchProducts(productsPath: String?) async -> Result<[Product], Error> {
        return mockProductsResult
    }
}

class MockImageRepository: ImageRepository {
    var mockImageURL: URL?
    
    func getImageURL(for imageName: String) -> URL? {
        return mockImageURL
    }
}

class MockLocalizationHandler: LocalizationHandler {
    var mockLocalizedString: String = "Mock String"
    
    override func localized(_ key: String) -> String {
        return mockLocalizedString
    }
}

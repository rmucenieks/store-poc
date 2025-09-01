# Testing Guide for UbuiquiteStorePoC

## Overview

This project includes a comprehensive test suite to ensure code quality and reliability. The tests cover models, view models, localization, and API services.

## Test Structure

### Test Targets

1. **UbuiquiteStorePoCTests** - Unit tests for the main app functionality
2. **UbuiquiteStorePoCUITests** - UI tests for user interface validation

### Test Files

- `UbuiquiteStorePoCTests.swift` - Main unit test file with basic model and localization tests

## Running Tests

### Option 1: Xcode IDE
1. Open the project in Xcode
2. Press `Cmd+U` to run all tests
3. Or use `Product > Test` from the menu

### Option 2: Command Line
```bash
# Run all tests
xcodebuild test -scheme UbuiquiteStorePoC -destination 'platform=iOS Simulator,name=iPhone 15'

# Run only unit tests
xcodebuild test -scheme UbuiquiteStorePoC -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:UbuiquiteStorePoCTests

# Run specific test class
xcodebuild test -scheme UbuiquiteStorePoC -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:UbuiquiteStorePoCTests/UbuiquiteStorePoCTests
```

### Option 3: Test Navigator
1. In Xcode, show the Test Navigator (`Cmd+6`)
2. Click the play button next to individual tests or test classes
3. Right-click to run specific tests

## Available Simulators

To see available simulators:
```bash
xcrun simctl list devices
```

Common simulator destinations:
```bash
# iPhone 15
-destination 'platform=iOS Simulator,id=43B55C18-3DAE-439C-A2D7-FFCC60F6C694'

# Any iOS Simulator
-destination 'platform=iOS Simulator,name=Any iOS Simulator Device'
```

## Test Coverage

### Current Tests

#### Model Tests
- ✅ Product initialization and properties
- ✅ ProductCategory initialization and properties  
- ✅ CartItem initialization and total price calculation

#### Localization Tests
- ✅ LocalizationHandler initialization
- ✅ Language switching (EN, LV, RU)
- ✅ Banner item creation with localization

#### Performance Tests
- ✅ LocalizationHandler performance measurement

### Planned Tests (Future Implementation)

#### ViewModel Tests
- StoreViewModel data loading and filtering
- CartViewModel cart operations
- ProductDetailViewModel product details

#### API Service Tests
- Network request mocking
- Error handling
- Data parsing

#### UI Tests
- Navigation flow
- User interactions
- Accessibility

## Test Data

### Mock Objects
- `MockLocalizer` - Simulates localization for testing
- Uses real model instances for realistic testing

### Test Data Sources
- `Product.productDemoItem` - Sample product for testing
- Localized strings from `.lproj` files
- Real model structures matching production code

## Writing New Tests

### Test Naming Convention
```swift
func test[Functionality][Scenario]() throws {
    // Arrange
    let testData = createTestData()
    
    // Act
    let result = functionUnderTest(testData)
    
    // Assert
    XCTAssertEqual(result, expectedValue)
}
```

### Test Structure
```swift
class MyFeatureTests: XCTestCase {
    
    var sut: MyFeature! // System Under Test
    
    override func setUpWithError() throws {
        sut = MyFeature()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testMyFeature() throws {
        // Test implementation
    }
}
```

### Async Testing
```swift
func testAsyncOperation() async throws {
    let expectation = XCTestExpectation(description: "Async operation completed")
    
    // Perform async operation
    let result = await asyncOperation()
    
    // Verify result
    XCTAssertNotNil(result)
    expectation.fulfill()
    
    await fulfillment(of: [expectation], timeout: 1.0)
}
```

## Troubleshooting

### Common Issues

1. **Simulator Launch Failures**
   - Reset simulator: `xcrun simctl erase all`
   - Check available simulators: `xcrun simctl list devices`

2. **Build Failures**
   - Clean build folder: `Cmd+Shift+K`
   - Clean derived data: `Product > Clean Build Folder`

3. **Test Execution Failures**
   - Check test target membership
   - Verify import statements
   - Check for main actor isolation issues

### Debug Commands

```bash
# Clean and rebuild
xcodebuild clean -scheme UbuiquiteStorePoC
xcodebuild build -scheme UbuiquiteStorePoC -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests with verbose output
xcodebuild test -scheme UbuiquiteStorePoC -destination 'platform=iOS Simulator,name=iPhone 15' -verbose
```

## Continuous Integration

### GitHub Actions (Future)
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Tests
        run: |
          xcodebuild test -scheme UbuiquiteStorePoC -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Best Practices

1. **Test Isolation**: Each test should be independent
2. **Descriptive Names**: Test names should clearly describe what they test
3. **Arrange-Act-Assert**: Structure tests in three clear sections
4. **Mock External Dependencies**: Don't rely on network or file system
5. **Test Edge Cases**: Include boundary conditions and error scenarios
6. **Performance Testing**: Use `measure` blocks for performance-critical code

## Resources

- [XCTest Framework Documentation](https://developer.apple.com/documentation/xctest)
- [Testing with Xcode](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/)
- [Swift Testing Best Practices](https://developer.apple.com/documentation/xcode/testing-your-apps-in-xcode)

## Support

For test-related issues:
1. Check this documentation
2. Review test output and error messages
3. Verify test target configuration
4. Check for model structure changes

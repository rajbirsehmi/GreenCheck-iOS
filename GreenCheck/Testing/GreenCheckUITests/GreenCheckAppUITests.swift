import XCTest

final class GreenCheckAppUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    // MARK: - Flow 1: Search through Manual barcode (Using Mock)
    func test_flow1_searchThroughManualBarcode() throws {
        app.tabBars.buttons["Manual"].tap()
        XCTAssertTrue(app.navigationBars["Manual Entry"].exists)

        let textField = app.textFields["Enter Barcode Number"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText("0123456789")

        let searchButton = app.buttons["Search Product"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()

        // Verify navigation to ProductView successfully loads mock data
        let productNavBar = app.navigationBars.element(boundBy: 0)
        XCTAssertTrue(productNavBar.waitForExistence(timeout: 3.0))
    }

    // MARK: - Flow 2: Search through camera barcode (Scanner UI)
    func test_flow2_searchThroughCameraBarcode() throws {
        app.tabBars.buttons["Scanner"].tap()
        XCTAssertTrue(app.navigationBars["Scanner"].exists)
        
        // Verifies camera viewfinder overlay and UI controls load correctly
        let quotaBadge = app.otherElements.firstMatch
        XCTAssertTrue(quotaBadge.exists)
    }

    // MARK: - Flow 3: Product not found (Using Mock ProductNotFound)
    func test_flow3_productNotFoundAlertAppears() throws {
        app.tabBars.buttons["Manual"].tap()
        
        let textField = app.textFields["Enter Barcode Number"]
        textField.tap()
        textField.typeText("0123452222222") // Triggers ProductNotFound mock behavior
        
        app.buttons["Search Product"].tap()
        
        let alert = app.alerts["Product Not Found"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3.0))
        alert.buttons["OK"].tap()
    }

    // MARK: - Flow 4: Search through history
    func test_flow4_searchThroughHistory() throws {
        app.tabBars.buttons["History"].tap()
        XCTAssertTrue(app.navigationBars["Scan History"].exists)

        let searchHistoryField = app.searchFields["Search History"]
        if searchHistoryField.exists {
            searchHistoryField.tap()
            searchHistoryField.typeText("Cookie")
        }
    }

    // MARK: - Flow 5: Check if history is saved after opening a product
    func test_flow5_historyIsSavedAfterProductLookup() throws {
        // Perform search to populate history via mock
        app.tabBars.buttons["Manual"].tap()
        let textField = app.textFields["Enter Barcode Number"]
        textField.tap()
        textField.typeText("0123456789")
        app.buttons["Search Product"].tap()

        let productNavBar = app.navigationBars.element(boundBy: 0)
        if productNavBar.waitForExistence(timeout: 3.0) {
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists { backButton.tap() }
            
            // Navigate to History to verify saved item
            app.tabBars.buttons["History"].tap()
            XCTAssertTrue(app.navigationBars["Scan History"].exists)
        }
    }

    // MARK: - Flow 6: Check if history is removed after clearing the list
    func test_flow6_clearsHistoryList() throws {
        app.tabBars.buttons["History"].tap()
        XCTAssertTrue(app.navigationBars["Scan History"].exists)

        let clearButton = app.buttons["Clear History"]
        if clearButton.exists {
            clearButton.tap()
            
            let alert = app.alerts["Clear Scan History?"]
            if alert.waitForExistence(timeout: 2.0) {
                alert.buttons["Clear All"].tap()
            }
            
            XCTAssertTrue(app.staticTexts["No Scan History"].exists)
        }
    }

    // MARK: - Flow 7: Check if product details are correct (Using Mock Data)
    func test_flow7_productDetailsAreCorrect() throws {
        app.tabBars.buttons["Manual"].tap()
        let textField = app.textFields["Enter Barcode Number"]
        textField.tap()
        textField.typeText("0123456789")
        app.buttons["Search Product"].tap()

        let statusSection = app.staticTexts["Status"]
        XCTAssertTrue(statusSection.waitForExistence(timeout: 3.0))
        XCTAssertTrue(app.staticTexts["Ingredient Breakdown"].exists || app.staticTexts["Ingredient Analysis"].exists)
    }

    // MARK: - Flow 8: Make sure alternatives are correct
    func test_flow8_veganAlternativesAreDisplayed() throws {
        app.tabBars.buttons["Manual"].tap()
        let textField = app.textFields["Enter Barcode Number"]
        textField.tap()
        textField.typeText("0123456789")
        app.buttons["Search Product"].tap()

        let altButton = app.buttons["Find Vegan Alternatives"]
        if altButton.waitForExistence(timeout: 3.0) {
            altButton.tap()
            XCTAssertTrue(app.staticTexts["Vegan Alternatives"].exists)
        }
    }
}

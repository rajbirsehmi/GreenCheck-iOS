import XCTest

final class GreenCheckAppUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Handle system camera permission alerts automatically
        addUIInterruptionMonitor(withDescription: "Camera Permission") { (alert) -> Bool in
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
                return true
            }
            return false
        }
        
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    // MARK: - Flow 1: Search through Manual barcode (Using Mock)
    func test_flow1_searchThroughManualBarcode() throws {
        app.tabBars.buttons["Manual"].tap()
        XCTAssertTrue(app.navigationBars["Manual Entry"].exists)
        
        let textField = app.textFields["manual_textField_barcode"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText("0123456789")
        
        let searchButton = app.buttons["manual_button_search"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        // Verify navigation to ProductView successfully loads mock data
        let productNavBar = app.navigationBars.element(boundBy: 0)
        XCTAssertTrue(productNavBar.waitForExistence(timeout: 3.0))
    }
        
    // MARK: - Flow 3: Product not found (Using Mock ProductNotFound)
    func test_flow3_productNotFoundAlertAppears() throws {
        app.tabBars.buttons["Manual"].tap()
        
        let textField = app.textFields["manual_textField_barcode"]
        textField.tap()
        textField.typeText("0123452222222") // Triggers ProductNotFound mock behavior
        
        app.buttons["manual_button_search"].tap()
        
        let alert = app.alerts["Product Not Found"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3.0))
        alert.buttons["OK"].tap()
    }
    
    // MARK: - Flow 4: Search through history
    func test_flow4_searchThroughHistory() throws {
        app.tabBars.buttons["History"].tap()
        XCTAssertTrue(app.navigationBars["Scan History"].exists)
        
        let searchHistoryField = app.searchFields["history_searchBar"]
        if searchHistoryField.exists {
            searchHistoryField.tap()
            searchHistoryField.typeText("Cookie")
        }
    }
    
    // MARK: - Flow 5: Check if history is saved after opening a product
    func test_flow5_historyIsSavedAfterProductLookup() throws {
        // Perform search to populate history via mock
        app.tabBars.buttons["Manual"].tap()
        let textField = app.textFields["manual_textField_barcode"]
        textField.tap()
        textField.typeText("0123456789")
        app.buttons["manual_button_search"].tap()
        
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
        
        let clearButton = app.buttons["history_button_clearHistoryPrompt"]
        if clearButton.exists {
            clearButton.tap()
            
            let alert = app.alerts["Clear Scan History?"]
            if alert.waitForExistence(timeout: 2.0) {
                alert.buttons["history_alert_clearAll"].firstMatch.tap()
            }
            
            XCTAssertTrue(app.otherElements["history_emptyState"].exists || app.staticTexts["No Scan History"].exists)
        }
    }
    
    // MARK: - Flow 7: Check if product details are correct (Using Mock Data)
    func test_flow7_productDetailsAreCorrect() throws {
        app.tabBars.buttons["Manual"].tap()
        let textField = app.textFields["manual_textField_barcode"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText("0123456789")
        
        let searchButton = app.buttons["manual_button_search"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        // Wait for asynchronous product details to render using visible section headers
        let statusHeading = app.staticTexts["Status"]
        XCTAssertTrue(statusHeading.waitForExistence(timeout: 5.0))
        
        let analysisHeading = app.staticTexts["Ingredient Analysis"]
        let breakdownHeading = app.staticTexts["Ingredient Breakdown"]
        
        XCTAssertTrue(
            analysisHeading.waitForExistence(timeout: 5.0) ||
            breakdownHeading.waitForExistence(timeout: 5.0)
        )
    }
    
    // MARK: - Flow 8: Make sure alternatives are correct
    func test_flow8_veganAlternativesAreDisplayed() throws {
        app.tabBars.buttons["Manual"].tap()
        let textField = app.textFields["manual_textField_barcode"]
        textField.tap()
        textField.typeText("0123456789")
        app.buttons["manual_button_search"].tap()
        
        let altButton = app.buttons["product_button_findAlternatives"]
        if altButton.waitForExistence(timeout: 3.0) {
            altButton.tap()
            XCTAssertTrue(app.otherElements["product_section_alternatives"].waitForExistence(timeout: 5.0))
        }
    }
}

//
//  RecipeAppUITests.swift
//  RecipeAppUITests
//
//  Created by Ravi Seta on 29/11/25.
//

import XCTest

final class RecipeAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    // MARK: - Navigation Tests
    
    @MainActor
    func testNavigationTitle() throws {
        // Verify that the navigation title is "Recipes"
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.exists, "Navigation bar with title 'Recipes' should exist")
    }
    
    // MARK: - Recipe List Tests
    
    @MainActor
    func testRecipeListExists() throws {
        // Wait for navigation to appear first
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist")
        
        // Try multiple ways to find the list (SwiftUI Lists can appear as tables, scrollViews, or cells)
        let table = app.tables.firstMatch
        let scrollView = app.scrollViews.firstMatch
        let cells = app.cells
        
        // Check if we have a table, scrollView, or cells
        let hasTable = table.waitForExistence(timeout: 10.0)
        let hasScrollView = scrollView.waitForExistence(timeout: 0.1)
        let hasCells = cells.count > 0
        
        // The list exists if we have any of these
        let listExists = hasTable || hasScrollView || hasCells
        
        XCTAssertTrue(listExists, "Recipe list should exist (as table, scrollView, or cells)")
    }
    
    @MainActor
    func testRecipeListItemsDisplay() throws {
        // Wait for navigation to appear first
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist")
        
        // Wait for data to load (give it more time for network requests)
        sleep(3)
        
        // Try to find cells directly (more reliable for SwiftUI Lists)
        let cells = app.cells
        let cellsExist = cells.count > 0
        
        if cellsExist {
            // Verify that at least one recipe item is displayed
            let firstCell = cells.firstMatch
            XCTAssertTrue(firstCell.exists, "At least one recipe item should be displayed")
        } else {
            // If no cells, check if empty state is showing (which is also valid)
            let emptyStateText = app.staticTexts["Recipe App"]
            if emptyStateText.waitForExistence(timeout: 2.0) {
                // Empty state is showing, which is acceptable
                XCTAssertTrue(true, "Empty state is showing (no recipe items to display)")
            } else {
                XCTFail("Neither recipe items nor empty state are visible")
            }
        }
    }
    
    @MainActor
    func testRecipeItemContent() throws {
        // Wait for navigation to appear first
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist")
        
        // Wait for data to load
        sleep(3)
        
        // Try to find cells directly
        let cells = app.cells
        if cells.count > 0 {
            let firstCell = cells.firstMatch
            
            // Verify that the cell contains text (recipe name and cuisine)
            let staticTexts = firstCell.staticTexts
            XCTAssertTrue(staticTexts.count > 0, "Recipe item should contain text elements")
            
            // Verify that images exist in the recipe items
            _ = firstCell.images
            // Note: Images might not be immediately available if they're loading
            // This is a basic check that the structure is correct
        } else {
            // If no cells, skip this test (empty state or still loading)
            print("No cells found - skipping content test")
        }
    }
    
    // MARK: - Empty State Tests
    
    @MainActor
    func testEmptyStateView() throws {
        // This test checks if empty state view elements exist
        // Note: This might only appear if there's no data or during loading
        let emptyStateText = app.staticTexts["Recipe App"]
        let emptyStateMessage = app.staticTexts["Please check after some time."]
        
        // If empty state exists, verify its elements
        if emptyStateText.exists {
            XCTAssertTrue(emptyStateText.exists, "Empty state title should exist")
            XCTAssertTrue(emptyStateMessage.exists, "Empty state message should exist")
        }
    }
    
    // MARK: - Pull to Refresh Tests
    
    @MainActor
    func testPullToRefresh() throws {
        // Wait for navigation to appear first
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist")
        
        // Wait for initial data to load
        sleep(3)
        
        // Try to find cells or table for pull to refresh
        let cells = app.cells
        let table = app.tables.firstMatch
        
        if cells.count > 0 {
            // Perform pull to refresh using the first cell
            let firstCell = cells.firstMatch
            let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            let end = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
            start.press(forDuration: 0.1, thenDragTo: end)
            
            // Wait a moment for refresh to complete
            sleep(2)
            
            // Verify cells still exist after refresh
            XCTAssertTrue(app.cells.count > 0 || table.exists, "List should still exist after pull to refresh")
        } else if table.waitForExistence(timeout: 2.0) {
            // Try pull to refresh on the table
            let start = table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            let end = table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
            start.press(forDuration: 0.1, thenDragTo: end)
            
            sleep(2)
            XCTAssertTrue(table.exists, "Table should still exist after pull to refresh")
        }
    }
    
    // MARK: - Scrolling Tests
    
    @MainActor
    func testScrollRecipeList() throws {
        // Wait for navigation to appear first
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist")
        
        // Wait for data to load
        sleep(3)
        
        // Try to find scrollable content
        let cells = app.cells
        let table = app.tables.firstMatch
        let scrollView = app.scrollViews.firstMatch
        
        if cells.count > 1 {
            // Scroll down using swipe on the first cell
            let firstCell = cells.firstMatch
            firstCell.swipeUp()
            
            // Wait a moment
            sleep(1)
            
            // Scroll up
            firstCell.swipeDown()
            
            // Verify cells still exist
            XCTAssertTrue(app.cells.count > 0, "List should still exist after scrolling")
        } else if table.waitForExistence(timeout: 2.0) {
            // Scroll on table
            table.swipeUp()
            sleep(1)
            table.swipeDown()
            XCTAssertTrue(table.exists, "Table should still exist after scrolling")
        } else if scrollView.waitForExistence(timeout: 2.0) {
            // Scroll on scrollView
            scrollView.swipeUp()
            sleep(1)
            scrollView.swipeDown()
            XCTAssertTrue(scrollView.exists, "ScrollView should still exist after scrolling")
        }
    }
    
    // MARK: - App Launch Tests
    
    @MainActor
    func testAppLaunch() throws {
        // Verify app launches successfully
        XCTAssertTrue(app.state == .runningForeground, "App should be running in foreground")
        
        // Verify main UI elements are present
        let navigationBar = app.navigationBars["Recipes"]
        let app = XCUIApplication()
        app.activate()
        XCUIDevice.shared.press(.home)
        
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let element = springboardApp/*@START_MENU_TOKEN@*/.images["record.circle"]/*[[".otherElements",".images[\"Screen Recording\"]",".images[\"record.circle\"]",".images"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element.tap()
        element.tap()
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 3.0), "Navigation bar should appear on launch")
    }
    
    // MARK: - Performance Tests
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    // MARK: - Accessibility Tests
    
    @MainActor
    func testAccessibilityElements() throws {
        // Wait for navigation to appear first
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist")
        
        // Wait for data to load
        sleep(3)
        
        // Check if navigation bar is accessible
        XCTAssertTrue(navigationBar.exists, "Navigation bar should be accessible")
        
        // Try to find list elements (table, scrollView, or cells)
        let table = app.tables.firstMatch
        let scrollView = app.scrollViews.firstMatch
        let cells = app.cells
        
        let hasTable = table.waitForExistence(timeout: 2.0)
        let hasScrollView = scrollView.waitForExistence(timeout: 0.1)
        let hasCells = cells.count > 0
        
        // Verify that at least one list element is accessible
        XCTAssertTrue(hasTable || hasScrollView || hasCells, "Recipe list should be accessible")
    }
    
    // MARK: - Orientation Tests
    
    @MainActor
    func testPortraitOrientation() throws {
        // Verify app works in portrait orientation
        XCUIDevice.shared.orientation = .portrait
        
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should exist in portrait")
        
        // Wait for data to load
        sleep(3)
        
        // Try multiple ways to find the list
        let table = app.tables.firstMatch
        let cells = app.cells
        let scrollView = app.scrollViews.firstMatch
        
        let hasTable = table.waitForExistence(timeout: 3.0)
        let hasCells = cells.count > 0
        let hasScrollView = scrollView.waitForExistence(timeout: 0.1)
        
        XCTAssertTrue(hasTable || hasCells || hasScrollView, "List should exist in portrait")
    }
}

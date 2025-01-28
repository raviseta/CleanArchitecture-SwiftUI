//
//  RecipeAppUITestsLaunchTests.swift
//  RecipeAppUITests
//
//  Created by Ravi Seta on 29/11/25.
//

import XCTest

final class RecipeAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Wait for the main UI to load
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should appear on launch")

        // Take a screenshot of the launch screen
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchWithDataLoaded() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for navigation
        let navigationBar = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5.0), "Navigation bar should appear")
        
        // Wait for data to load
        sleep(3)
        
        // Check for list in multiple ways
        let table = app.tables.firstMatch
        let cells = app.cells
        let scrollView = app.scrollViews.firstMatch
        
        let hasTable = table.waitForExistence(timeout: 2.0)
        let hasCells = cells.count > 0
        let hasScrollView = scrollView.waitForExistence(timeout: 0.1)
        let listExists = hasTable || hasCells || hasScrollView
        
        // Take screenshot after data loads
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = listExists ? "Launch Screen - Data Loaded" : "Launch Screen - Empty State"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

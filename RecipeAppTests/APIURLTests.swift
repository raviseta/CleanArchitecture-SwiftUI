//
//  APIURLTests.swift
//  RecipeApp
//
//  Created by Ravi Seta on 26/01/25.
//

import XCTest
@testable import RecipeApp

class APIURLTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testgetRecipeListURL() throws {
        let url = APIURL.getRecipeList.getURL()
        XCTAssertEqual(url, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    }
    
}

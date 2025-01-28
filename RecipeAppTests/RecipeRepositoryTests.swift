//
//  RecipeRepositoryTests.swift
//  RecipeApp
//
//  Created by Ravi Seta on 26/01/25.
//

import XCTest
@testable import RecipeApp

class RecipeRepositoryTests: XCTestCase {
    
    var sut: RecipeListRepository!
    
    override func setUp() {
        super.setUp()
        sut = RecipeListRepository(netWorkManager: NetWorkManager())
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testRecipeWebService_WhenGiveSuccess() async throws {
        let expect = XCTestExpectation(description: "API Call Success")
        do {
            let response = try await sut.getRecipes(endpoint: .getRecipeList)
            XCTAssertNotNil(response)
            expect.fulfill()
            
        } catch {
            
        }
        
        await fulfillment(of: [expect], timeout: 5.0)
    }
    
    func testRecipeWebService_WhenGivenFail() async throws {
        let expect = XCTestExpectation(description: "API Call Fail")
        
        // Use explicit capture of `self` in the closure
        Task { [weak self] in
            guard let self = self else { return } // Safely unwrap `self`
            
            do {
                _ = try await self.sut.getRecipes(endpoint: .none)
                XCTFail("API call succeeded, but was expected to fail.")
            } catch {
                XCTAssertNotNil(error)
            }
            
            expect.fulfill() // Fulfill expectation regardless of success or failure
        }
        
        // Use `await fulfillment` for asynchronous waiting
        await fulfillment(of: [expect], timeout: 5.0)
    }
    
}

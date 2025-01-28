//
//  MockRecipeListUseCase.swift
//  RecipeApp
//
//  Created by Ravi Seta on 27/01/25.
//


import XCTest
import Combine
@testable import RecipeApp

// Mock for RecipeListUseCaseProtocol
class MockRecipeListUseCase: RecipeListUseCaseProtocol {
    
    var shouldThrowError = false
    var mockRecipes: [Recipe] = []
    
    func getRecipeList() async throws -> [Recipe] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockRecipes
    }
}

final class RecipelistViewModelTests: XCTestCase {
    
    var mockUseCase: MockRecipeListUseCase!
    var viewModel: RecipelistViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockRecipeListUseCase()
        viewModel = RecipelistViewModel(recipeListUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetRecipeData_Success() async throws {
        // Arrange
        let mockRecipes = [
            Recipe(uuid: "1", cuisine: "Italian", name: "Pizza", imageURL: "https://example.com/pizza.jpg"),
            Recipe(uuid: "2", cuisine: "Indian", name: "Curry", imageURL: "https://example.com/curry.jpg")
        ]
        mockUseCase.mockRecipes = mockRecipes
        let expectation = XCTestExpectation(description: "Recipe data should be updated successfully")
        
        // Observe the `recipe` property
        viewModel.$recipe
            .dropFirst() // Ignore initial state
            .sink { recipes in
                if recipes.count == 2, case .data = recipes.first {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.getRecipeData()
        
        // Wait for expectation
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Assert
        XCTAssertEqual(viewModel.recipe.count, 2, "Recipe count should match mock data.")
        XCTAssertEqual(viewModel.recipe.first?.data?.recipeName, "Pizza", "First recipe name should match mock data.")
    }
    
    func testGetRecipeData_Failure() async {
        // Arrange
        mockUseCase.shouldThrowError = true
        let expectation = XCTestExpectation(description: "Error message should be updated on failure")
        
        // Observe the `errorMessage` property
        viewModel.$errorMessage
            .dropFirst() // Ignore initial state
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        viewModel.getRecipeData()
        
        // Wait for expectation
        await fulfillment(of: [expectation], timeout: 2.0)

        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil on failure.")
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (TestError error 1.)", "Error message should match the thrown error.")
    }
}

//
//  MockRecipeListRepository.swift
//  RecipeApp
//
//  Created by Ravi Seta on 27/01/25.
//


import XCTest
@testable import RecipeApp

// Mock implementation of RecipeListRepositoryProtocol
class MockRecipeListRepository: RecipeListRepositoryProtocol {
    
    var shouldThrowError = false
    var mockRecipes: [RecipeDTO] = []

    func getRecipes(endpoint: APIURL) async throws -> [RecipeDTO] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockRecipes
    }
}

final class RecipeListUseCaseTests: XCTestCase {
    
    var mockRepository: MockRecipeListRepository!
    var useCase: RecipeListUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeListRepository()
        useCase = RecipeListUseCase(recipeListRepository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func testGetRecipeList_Success() async throws {
        // Arrange
        let mockRecipes = try RecipeListMockDataGenerator.mockRecipeList()
        mockRepository.mockRecipes = mockRecipes

        // Act
        let recipes = try await useCase.getRecipeList()

        // Assert
        XCTAssertEqual(recipes.count, 63, "Recipe count should match mock data.")
        XCTAssertEqual(recipes[0].name, "Apam Balik", "First recipe name should match mock data.")
        XCTAssertEqual(recipes[1].cuisine, "British", "Second recipe cuisine should match mock data.")
    }

    func testGetRecipeList_Failure() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.getRecipeList()
            XCTFail("getRecipeList should throw an error when the repository fails.")
        } catch {
            XCTAssertNotNil(error, "Error should not be nil when repository fails.")
        }
    }
}

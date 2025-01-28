//
//  RecipeListUseCase.swift
//  RecipeApp
//
//  Created by Ravi Seta on 24/01/25.
//

import Foundation

protocol RecipeListUseCaseProtocol {
    func getRecipeList() async throws -> [Recipe]
}

public class RecipeListUseCase: RecipeListUseCaseProtocol {
    
    let recipeListRepository: RecipeListRepositoryProtocol

    init(recipeListRepository: RecipeListRepositoryProtocol) {
        self.recipeListRepository = recipeListRepository
    }

    func getRecipeList() async throws -> [Recipe] {
        let recipeDTO = try await recipeListRepository.getRecipes(endpoint: .getRecipeList)
        let recipes = recipeDTO.compactMap({Recipe(uuid: $0.uuid, cuisine: $0.cuisine, name: $0.name, imageURL: $0.photoURLLarge )})
        return recipes
    }
}

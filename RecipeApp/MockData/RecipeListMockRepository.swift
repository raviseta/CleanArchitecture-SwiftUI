//
//  RecipeListMockRepository.swift
//  RecipeApp
//
//  Created by Ravi Seta on 26/01/25.
//

import Foundation

enum Response {
    case success
    case error
}

class RecipeListMockRepository: RecipeListRepositoryProtocol {
        
    var response: Response = .success
    
    func getRecipes(endpoint: APIURL) async throws -> [RecipeDTO] {
        switch response {
        case .success:
            if !(Reachability.isConnectedToNetwork()) {
                throw APIError.noInternet
            }
            if endpoint == .none {
                throw APIError.invalidURL
            }
            do {
                let recipes = try RecipeListMockDataGenerator.mockRecipeList()
                return recipes
            } catch {
                throw error
            }
            
        case .error :
            throw APIError.invalidResponse
        }
    }
    
}

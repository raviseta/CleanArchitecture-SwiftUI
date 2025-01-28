//
//  RecipeListMockDataGenerator.swift
//  RecipeApp
//
//  Created by Ravi Seta on 26/01/25.
//

import Foundation

class RecipeListMockDataGenerator {
    static func mockRecipeList() throws -> [RecipeDTO] {
        guard  let path = Bundle.main.path(forResource: "RecipeData", ofType: "json")
        else {
            throw APIError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let response = try decoder.decode(RecipeList.self, from: data)
            return response.recipes
        } catch {
            throw APIError.fileNotFound
        }
    }
    
}

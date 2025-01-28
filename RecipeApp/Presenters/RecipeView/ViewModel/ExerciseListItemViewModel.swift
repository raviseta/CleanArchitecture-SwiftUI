//
//  ExerciseListItemViewModel.swift
//  RecipeApp
//
//  Created by Ravi Seta on 25/01/25.
//

import Foundation

class RecipeListItemViewModel: Identifiable, ObservableObject {
    let id: String
    let recipeName: String
    let cuisineType: String
    let imageUrl: String
    
    init(
        id: String,
        recipeName: String,
        cuisineType: String,
        imageUrl: String
    ) {
        self.id = id
        self.recipeName = recipeName
        self.cuisineType = cuisineType
        self.imageUrl = imageUrl
    }
}

extension RecipeListItemViewModel {
    static var placeholder: RecipeListItemViewModel {
        return .init(
            id: UUID().uuidString,
            recipeName: .dummyLongText,
            cuisineType: .dummyLongText,
            imageUrl: "https://example.com/food.png"
        )
    }
}

extension RecipeListItemViewModel {
    
    convenience init(item: Recipe) {
        self.init(
            id: item.uuid,
            recipeName: item.name,
            cuisineType: item.cuisine,
            imageUrl: item.imageURL
        
        )
    }
}

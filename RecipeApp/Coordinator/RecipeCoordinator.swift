//
//  RecipeCoordinator.swift
//  RecipeApp
//
//  Created by Ravi Seta on 25/01/25.
//

import SwiftUI

protocol RecipeCoordinator {
    associatedtype ContentView: View
    func start() -> ContentView
}

class RecipeCoordinatorImpl: RecipeCoordinator {
    
    func start() -> some View {
    
        let recipeRepository = RecipeListRepository(netWorkManager: NetWorkManager())
        let recipeListUseCase = RecipeListUseCase(recipeListRepository: recipeRepository)
        let recipeListViewModel = RecipelistViewModel(recipeListUseCase: recipeListUseCase)
        let recipeListView = RecipeListView(viewModel: recipeListViewModel)        
        return recipeListView
        
    }
}

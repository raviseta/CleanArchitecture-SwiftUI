//
//  RecipelistViewModel.swift
//  RecipeApp
//
//  Created by Ravi Seta on 24/01/25.
//

import Foundation

class RecipelistViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var recipe: [CellDataSource<RecipeListItemViewModel>] = []
    @Published var alertToDisplay: AlertData?

    let recipeListUseCase: RecipeListUseCaseProtocol
    
    init(recipeListUseCase: RecipeListUseCaseProtocol) {
        self.recipeListUseCase = recipeListUseCase
    }
    
    func getRecipeData() {
        self.recipe = [.loader(.init()), .loader(.init()), .loader(.init()) ]

        Task {
            do {
               let response = try await recipeListUseCase.getRecipeList()
                await MainActor.run {
                    self.recipe = response.map({.data(.init(item: $0))})
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.alertToDisplay = .init(error: error)
                }
            }
        }
    }
}

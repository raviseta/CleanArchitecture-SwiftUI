//
//  RecipeListView.swift
//  RecipeApp
//
//  Created by Ravi Seta on 24/01/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel: RecipelistViewModel
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                
                recipeListView
            }
            .navigationTitle("Recipes")
            .alert(for: $viewModel.alertToDisplay)
            .onAppear {
                viewModel.getRecipeData()
            }
            .refreshable { // For Pull to Refresh
                viewModel.getRecipeData()
            }
        }
    }
    
    @ViewBuilder
    var recipeListView: some View {
        if viewModel.recipe.isEmpty {
            
            emptyStateView
            
        } else {
            List(viewModel.recipe, id: \.id) { data in
                switch data {
                case .loader(_):
                    self.prepareListItem(model: .placeholder)
                        .shimmering()
                    
                case .data(let model):
                    self.prepareListItem(model: model)
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder
    var emptyStateView: some View {
        EmptyStateView(
            viewModel: .init(
                image: .placeHolderImage,
                title: applicationName,
                message: ErrorMessage.emptyState.rawValue,
                size: .init(width: 72, height: 72)
            )
        )
        .frame(maxHeight: .infinity)
    }
    
    func prepareListItem(model: RecipeListItemViewModel) -> some View {
        RecipeListItem(viewModel: model)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
            .background(Color.getAppColor(.gray30))
        
    }
}

#Preview {
    RecipeListView(viewModel: RecipelistViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepository(netWorkManager: NetWorkManager()))))
}

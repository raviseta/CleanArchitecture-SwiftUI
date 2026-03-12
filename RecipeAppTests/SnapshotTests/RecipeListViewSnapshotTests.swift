//
//  RecipeListViewSnapshotTests.swift
//  RecipeAppTests
//

import XCTest
import SwiftUI
@testable import RecipeApp

final class RecipeListViewSnapshotTests: SnapshotTestCase {

    private let snapshotSize = CGSize(width: 390, height: 844)

    // Tests the empty state shown when there are no recipes.
    // State is set directly on the ViewModel before rendering so that
    // onAppear / getRecipeData() does not interfere with the snapshot.
    @MainActor
    func testRecipeListView_EmptyState() {
        let viewModel = makeViewModel()
        // recipe defaults to [], which triggers the empty-state branch
        let view = RecipeListView(viewModel: viewModel)

        assertSnapshot(of: view, size: snapshotSize)
    }

    // Tests the loading skeleton shown while recipes are being fetched.
    @MainActor
    func testRecipeListView_LoadingState() {
        let viewModel = makeViewModel()
        viewModel.recipe = [
            .loader(.init()),
            .loader(.init()),
            .loader(.init())
        ]
        let view = RecipeListView(viewModel: viewModel)

        assertSnapshot(of: view, size: snapshotSize)
    }

    // Tests the populated list with multiple recipe rows.
    // Image URLs are empty so no network requests are made.
    @MainActor
    func testRecipeListView_WithData() {
        let viewModel = makeViewModel()
        viewModel.recipe = [
            .data(RecipeListItemViewModel(id: "1", recipeName: "Apam Balik", cuisineType: "Malaysian", imageUrl: "")),
            .data(RecipeListItemViewModel(id: "2", recipeName: "Apple Frangipan Tart", cuisineType: "British", imageUrl: "")),
            .data(RecipeListItemViewModel(id: "3", recipeName: "Bakewell Tart", cuisineType: "British", imageUrl: "")),
        ]
        let view = RecipeListView(viewModel: viewModel)

        assertSnapshot(of: view, size: snapshotSize)
    }

    // MARK: - Helpers

    private func makeViewModel() -> RecipelistViewModel {
        let mock = MockRecipeListUseCase()
        return RecipelistViewModel(recipeListUseCase: mock)
    }
}

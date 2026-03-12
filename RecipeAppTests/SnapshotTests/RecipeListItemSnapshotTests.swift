//
//  RecipeListItemSnapshotTests.swift
//  RecipeAppTests
//

import XCTest
import SwiftUI
@testable import RecipeApp

final class RecipeListItemSnapshotTests: SnapshotTestCase {

    private let snapshotSize = CGSize(width: 390, height: 100)

    // Tests a recipe list item with typical data.
    // Image URL is empty so no network request is made – image area renders as blank.
    @MainActor
    func testRecipeListItem_WithData() {
        let viewModel = RecipeListItemViewModel(
            id: "snapshot-test-id",
            recipeName: "Apam Balik",
            cuisineType: "Malaysian",
            imageUrl: ""
        )
        let view = RecipeListItem(viewModel: viewModel)
            .frame(width: snapshotSize.width, height: snapshotSize.height)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
            .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))

        assertSnapshot(of: view, size: snapshotSize)
    }

    // Tests a recipe item with a long recipe name to verify truncation/wrapping.
    @MainActor
    func testRecipeListItem_LongRecipeName() {
        let viewModel = RecipeListItemViewModel(
            id: "snapshot-test-long",
            recipeName: "Traditional Malaysian Coconut Pancake with Peanut Filling",
            cuisineType: "Malaysian",
            imageUrl: ""
        )
        let view = RecipeListItem(viewModel: viewModel)
            .frame(width: snapshotSize.width, height: snapshotSize.height)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
            .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))

        assertSnapshot(of: view, size: snapshotSize)
    }

    // Tests the placeholder state used during shimmer loading.
    @MainActor
    func testRecipeListItem_Placeholder() {
        let viewModel = RecipeListItemViewModel.placeholder
        let view = RecipeListItem(viewModel: viewModel)
            .frame(width: snapshotSize.width, height: snapshotSize.height)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
            .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))

        assertSnapshot(of: view, size: snapshotSize)
    }
}

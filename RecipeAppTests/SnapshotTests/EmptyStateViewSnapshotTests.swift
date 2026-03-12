//
//  EmptyStateViewSnapshotTests.swift
//  RecipeAppTests
//

import XCTest
import SwiftUI
@testable import RecipeApp

final class EmptyStateViewSnapshotTests: SnapshotTestCase {

    private let snapshotSize = CGSize(width: 390, height: 400)

    // Tests the default empty state shown when no recipes are available.
    @MainActor
    func testEmptyStateView_Default() {
        let viewModel = EmptyStateViewModel(
            image: .placeHolderImage,
            title: applicationName,
            message: ErrorMessage.emptyState.rawValue,
            size: .init(width: 72, height: 72)
        )
        let view = EmptyStateView(viewModel: viewModel)
            .frame(width: snapshotSize.width, height: snapshotSize.height)
            .background(Color.white)

        assertSnapshot(of: view, size: snapshotSize)
    }

    // Tests empty state with a long title and message to verify text wrapping.
    @MainActor
    func testEmptyStateView_LongText() {
        let viewModel = EmptyStateViewModel(
            image: .placeHolderImage,
            title: "Recipe App – No Recipes Found",
            message: "We couldn't load any recipes. Please try again later or check your internet connection.",
            size: .init(width: 72, height: 72)
        )
        let view = EmptyStateView(viewModel: viewModel)
            .frame(width: snapshotSize.width, height: snapshotSize.height)
            .background(Color.white)

        assertSnapshot(of: view, size: snapshotSize)
    }
}

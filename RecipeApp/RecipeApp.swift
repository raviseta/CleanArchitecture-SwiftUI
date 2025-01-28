//
//  RecipeApp.swift
//  RecipeApp
//
//  Created by Ravi Seta on 24/01/25.
//

import SwiftUI

@main
struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            let coordinator = RecipeCoordinatorImpl()
            coordinator.start()
        }
    }
}

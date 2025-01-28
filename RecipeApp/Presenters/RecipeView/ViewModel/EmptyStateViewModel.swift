//
//  EmptyStateViewModel.swift
//  RecipeApp
//
//  Created by Ravi Seta on 27/01/25.
//

import Foundation

struct EmptyStateViewModel {
    init(
        image: Images,
        title: String,
        message: String,
        size: CGSize = .init(width: 200, height: 200)
    ) {
        self.image = image
        self.title = title
        self.message = message
        self.size = size
    }
    
    let image: Images
    let title: String
    let message: String
    let size: CGSize
}

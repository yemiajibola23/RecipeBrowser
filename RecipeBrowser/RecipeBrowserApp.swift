//
//  RecipeBrowserApp.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

@main
struct RecipeBrowserApp: App {
    let container = DependencyContainer.shared
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: container.makeRecipeListViewModel())
        }
    }
}

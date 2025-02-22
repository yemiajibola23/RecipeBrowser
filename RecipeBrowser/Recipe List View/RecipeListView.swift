//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeListView: View {
    let container = DependencyContainer.shared
    @Bindable var viewModel: RecipeListViewModel
    
    var body: some View {
        List(viewModel.recipes) { recipe in
            RecipeItemView(viewModel: container.makeRecipeItemViewModel(recipe: recipe))
        }
        .onAppear {
            Task { await viewModel.loadRecipes(from: API.url()) }
        }
        .padding()
    }
}

//#Preview {
//    RecipeListView(viewModel: container.makeRecipeListViewModel())
//}

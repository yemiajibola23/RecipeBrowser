//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

let container = DependencyContainer.shared

struct RecipeListView: View {
    @Bindable var viewModel: RecipeListViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.loadRecipes() }
                }
            } else if viewModel.recipes.isEmpty {
                EmptyStateView(message: RecipeListViewModel.ErrorMessages.empty.rawValue)
            } else {
                List(viewModel.recipes) { recipe in
                    RecipeItemView(viewModel: container.makeRecipeItemViewModel(recipe: recipe))
                }
                .padding()
            }
            
        }
        .onAppear {
            Task { await viewModel.loadRecipes(from:.all) }
        }

    }
}

//#Preview {
//    RecipeListView(viewModel: container.makeRecipeListViewModel())
//}

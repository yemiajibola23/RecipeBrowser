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
                ProgressView("Loading recipes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.loadRecipes(forceRefresh: true) }
                }
            } else if viewModel.recipes.isEmpty {
                EmptyStateView(message: "No recipes available")
            } else {
                NavigationView {
                    List(viewModel.filteredRecipes) { recipe in
                        RecipeItemView(viewModel: container.makeRecipeItemViewModel(recipe: recipe))
                    }
                    .padding()
                    .navigationTitle("Recipes")
                    .refreshable { await viewModel.loadRecipes(forceRefresh: true) }
                    .searchable(text: $viewModel.searchQuery, prompt: "Search recipes...")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Menu {
                                Button("All", action: { viewModel.selectedCuisine = nil})
                                
                                ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                                    Button(cuisine, action: { viewModel.selectedCuisine = cuisine })
                                }
                            } label: {
                                Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                            }
                        }
                        //
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button("Name A-Z", action: { viewModel.sortOption = .nameAscending })
                                Button("Name Z-A", action: { viewModel.sortOption = .nameDescending })
                                Button("Cuisine A-Z", action: { viewModel.sortOption = .cuisineAscending })
                                Button("Cuisine Z-A", action: { viewModel.sortOption = .cuisineDescending })
                            } label: {
                                Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task { await viewModel.loadRecipes(from: .malformed) }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An unexpected error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

//#Preview {
//    RecipeListView(viewModel: container.makeRecipeListViewModel())
//}

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
        NavigationStack {
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
                    ScrollView {
                        LazyVStack(spacing: 4) {
                            ForEach(viewModel.filteredRecipes, id: \.id) { recipe in
                                let viewModel = container.makeRecipeViewModel(recipe: recipe)
                                NavigationLink {
                                    RecipeDetailView(viewModel: viewModel)
                                } label: {
                                    RecipeItemView(viewModel: viewModel)
                                        .tint(.primary)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .navigationTitle("Recipes")
                        .refreshable { await viewModel.loadRecipes(forceRefresh: true) }
                        .searchable(text: $viewModel.searchQuery, prompt: "Search recipes...")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Menu {
                                    Button("All", action: { viewModel.selectedCuisine = nil })
                                    
                                    ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                                        Button(cuisine.displayName, action: { viewModel.selectedCuisine = cuisine })
                                    }
                                } label: {
                                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Menu {
                                    Picker("Sort By", selection: $viewModel.sortOption) {
                                        Text("Name").tag(RecipeListViewModel.SortBy.name)
                                        Text("Cuisine").tag(RecipeListViewModel.SortBy.cuisine)
                                    }
                                    
                                    Toggle("Ascending", isOn: $viewModel.isAscending)
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Change here for different json options.
                Task { await viewModel.loadRecipes(from: .all) }
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
}

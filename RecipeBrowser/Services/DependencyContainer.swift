//
//  DependencyContainer.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/21/25.
//


import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    let networkService: NetworkServiceProtocol
    let imageManager: ImageManagerProtocol
    
    private init() {
        networkService = NetworkService(session: .shared)
        imageManager = ImageManager(
            diskCache: DiskCache(),
            memoryCache: InMemoryCache(),
            downloader: ImageDownloader(networkService: networkService))
    }
    
    func makeRecipeManager() -> RecipeManager { RecipeManager(networkService: networkService) }
    
    func makeRecipeViewModel(recipe: Recipe) -> RecipeViewModel { RecipeViewModel(recipe: recipe, imageManager: imageManager) }
    
    func makeRecipeListViewModel() -> RecipeListViewModel { RecipeListViewModel(recipeManager: makeRecipeManager()) }
}

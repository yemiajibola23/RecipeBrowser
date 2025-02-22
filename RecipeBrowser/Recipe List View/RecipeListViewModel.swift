//
//  RecipeListViewModel.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/20/25.
//

import Observation
import Foundation

@Observable
class RecipeListViewModel {
    private let recipeManager: RecipeManagerProtocol
    
    var recipes: [Recipe] = []
    var errorMessage: String?
    var isLoading = false
    
    init(recipeManager: RecipeManagerProtocol) {
        self.recipeManager = recipeManager
    }
    
    enum ErrorMessages: String {
        case empty = "No recipes available."
        case failed = "Failed to load recipes."
    }
    
    func loadRecipes(from url: URL = API.url()) async {
        isLoading = true
        do {
            let fetchedRecipes = try await recipeManager.fetchRecipes(from: url)
            if fetchedRecipes.isEmpty {
                errorMessage = ErrorMessages.empty.rawValue
            } else {
                recipes = fetchedRecipes
            }
        } catch {
            recipes = []
            errorMessage = ErrorMessages.failed.rawValue
        }
        
        isLoading = false
    }
}

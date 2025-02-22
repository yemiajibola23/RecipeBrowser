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
    
    func loadRecipes(from endpoint: API.Endpoint = .all) async {
        isLoading = true
        do {
            recipes = try await recipeManager.fetchRecipes(from: API.url(for: endpoint))
        } catch {
            recipes = []
            errorMessage = ErrorMessages.failed.rawValue
        }
        
        isLoading = false
    }
}

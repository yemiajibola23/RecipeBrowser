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
    let recipeManager: RecipeManagerProtocol
    
    var recipes: [Recipe] = []
    var errorMessage: String?
    
    init(recipeManager: RecipeManagerProtocol) {
        self.recipeManager = recipeManager
    }
    
    func loadRecipes(from url: URL) async {
        do {
            recipes = try await recipeManager.fetchRecipes(from: url)
            errorMessage = nil
        } catch {
            recipes = []
            errorMessage = error.localizedDescription
        }
    }
}

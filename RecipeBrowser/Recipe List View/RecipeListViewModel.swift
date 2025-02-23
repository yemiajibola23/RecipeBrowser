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
    var showAlert = false
    
    init(recipeManager: RecipeManagerProtocol) {
        self.recipeManager = recipeManager
    }

    func loadRecipes(from endpoint: API.Endpoint = .all) async {
        isLoading = true
        do {
            recipes = try await recipeManager.fetchRecipes(from: API.url(for: endpoint))
            errorMessage = nil
            showAlert = false
            print("✅ Recipes updated: \(recipes.count)")
        } catch {
            recipes.removeAll()
            errorMessage = getErrorMessage(for: error as? RecipeManager.Error ?? .unknown)
            showAlert = true
            print("❌ Error fetching recipes: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func getErrorMessage(for error: RecipeManager.Error) -> String {
        switch error {
        case .network(let networkError): return getNetworkErrorMessage(for: networkError)
        case .decoding: return "We encountered an issue while trying to load the recipes. Please try again later."
        case .unknown: return "An unknown error occurred. Please try again later."
        }
    }
    
    private func getNetworkErrorMessage(for error: NetworkService.Error) -> String {
        switch error {
        case .invalidURL: return "The server's URL is incorrect. Please contact support."
        case .networkFailure(let statusCode): return "Network error (\(statusCode)). Please check your internet connection."
        case .unknown: return "An unknown error occurred. Please try again later."
        }
    }
}

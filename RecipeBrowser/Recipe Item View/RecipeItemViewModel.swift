//
//  ImageViewModel.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit
import Observation

@Observable
class RecipeItemViewModel {
    
    private var cacheManager: ImageManagerProtocol
    
    var image: UIImage?
    var isLoading = false
    var errorMessage: String?
    
    var name: String { recipe.name }
    var cuisine: String { recipe.cuisine }
    
    let recipe: Recipe
    
    init(recipe: Recipe, cacheManager: ImageManagerProtocol) {
        self.recipe = recipe
        self.cacheManager = cacheManager
    }
    
    func loadImage() async {
        isLoading = true
        errorMessage = nil
        
        do {
            if let urlString = recipe.smallPhotoURL, let url = URL(string: urlString), let fetchedImage = try await cacheManager.loadImage(from: url) {
                image = fetchedImage
            } else {
                errorMessage = "Failed to load image."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

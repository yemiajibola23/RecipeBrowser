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
    
    private var cacheManager: ImageCacheProtocol
    var image: UIImage?
    var isLoading = false
    var errorMessage: String?
    
    let recipe: Recipe
    init(recipe: Recipe, cacheManager: ImageCacheProtocol) {
        self.recipe = recipe
        self.cacheManager = cacheManager
    }
    
    var name: String { recipe.name }
    var cuisine: String { recipe.cuisine }
    
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

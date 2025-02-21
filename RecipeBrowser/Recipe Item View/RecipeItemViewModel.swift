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
    private var imageManager: ImageManagerProtocol
    
    var image: UIImage?
    var isLoading = false
    var errorMessage: String?
    
    var name: String { recipe.name }
    var cuisine: String { recipe.cuisine }
    
    let recipe: Recipe
    
    init(recipe: Recipe, imageManager: ImageManagerProtocol) {
        self.recipe = recipe
        self.imageManager = imageManager
    }
    
    func loadImage() async {
        isLoading = true
        errorMessage = nil
        
        do {
            if let urlString = recipe.smallPhotoURL,
                let url = URL(string: urlString),
                let fetchedImage = try await imageManager.loadImage(from: url) {
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

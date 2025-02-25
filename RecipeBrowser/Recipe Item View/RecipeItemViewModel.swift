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
    var errorMessage: String?
    var isLoading = false
    
    var name: String { recipe.name }
    var cuisine: String { recipe.cuisine }
    
    let recipe: Recipe
    
    init(recipe: Recipe, imageManager: ImageManagerProtocol) {
        self.recipe = recipe
        self.imageManager = imageManager
        print("Recipe Item View Model was initialized!")
    }
    
    deinit {
        print("Recipe Item View Model was deinitialized!")
    }
    
    func loadImage() async {
        isLoading = true
        errorMessage = nil
        
        print("Load image was called!")
        
        do {
//            try await Task.sleep(nanoseconds: 3_000_000_000) // Used to simulate a delay 
            if let urlString = recipe.smallPhotoURL,
                let url = URL(string: urlString),
                let fetchedImage = try await imageManager.loadImage(from: url) {
                image = fetchedImage
                errorMessage = nil
            } else {
                errorMessage = "Failed to load image."
                image = nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

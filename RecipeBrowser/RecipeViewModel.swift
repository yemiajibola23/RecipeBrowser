//
//  RecipeViewModel.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit
import Observation

@Observable
class RecipeViewModel {
    private var imageManager: ImageManagerProtocol
    
    var smallImage: UIImage?
    var largeImage: UIImage?
    var errorMessage: String?
   
    var isLoadingSmallImage = false
    var isLoadingLargeImage = false
    
    var name: String { recipe.name }
    var cuisine: Cuisine { recipe.cuisine }
    var recipeID: String { recipe.id }
    var youtubeURL: URL? { recipe.youtubeURL?.toYouTubeEmbedURL() }
    var sourceURL: URL? {
        guard let urlString = recipe.sourceURL else { return nil }
        return URL(string: urlString)
    }
    
    private let recipe: Recipe
    
    init(recipe: Recipe, imageManager: ImageManagerProtocol) {
        self.recipe = recipe
        self.imageManager = imageManager
        
        // Work around for images not loading when filter/sort shows up
        if let urlString = recipe.smallPhotoURL, let url = URL(string: urlString) {
            smallImage = imageManager.getCachedImage(for: url)
        }
        
//        print("Recipe Item View Model was initialized!")
    }
    
    func loadSmallImage() async {
        await loadImage(for: recipe.smallPhotoURL, into: \.smallImage, loadingFlag: \.isLoadingSmallImage)
    }
    
    func loadLargeImage() async {
        await loadImage(for: recipe.largePhotoURL, into: \.largeImage, loadingFlag: \.isLoadingLargeImage)

    }

    private func loadImage(for urlString: String?, into imageKey: ReferenceWritableKeyPath<RecipeViewModel, UIImage?>, loadingFlag: ReferenceWritableKeyPath<RecipeViewModel, Bool>) async {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            errorMessage = "Invalid image url"
            return
        }
        
        print("Load image was called!")
        self[keyPath: loadingFlag] = true
        
        defer { self[keyPath: loadingFlag] = false }
        
        do {
//            try await Task.sleep(nanoseconds: 3_000_000_000) // Used to simulate a delay 
               if let fetchedImage = try await imageManager.loadImage(from: url) {
                   self[keyPath: imageKey] = fetchedImage
            } else {
                errorMessage = "Failed to load image."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

extension String {
    func toYouTubeEmbedURL() -> URL? {
        guard let url = URL(string: self),
              let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
              let videoID = query.first(where: { $0.name == "v" })?.value else {
            return nil
        }
        return URL(string: "https://www.youtube.com/embed/\(videoID)")
    }
}

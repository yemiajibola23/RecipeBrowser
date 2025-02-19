//
//  ImageViewModel.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit

class ImageViewModel {
    private var cacheManager: ImageCacheProtocol
    var image: UIImage?
    var isLoading = false
    var errorMessage: String?
    
    init(cacheManager: ImageCacheProtocol) {
        self.cacheManager = cacheManager
    }
    
    func loadImage(from url: URL) async {
        isLoading = true
        print("is Loading is true.")
        errorMessage = nil
        
        do {
            if let fetchedImage = try await cacheManager.loadImage(from: url) {
                image = fetchedImage
            } else {
                errorMessage = "Failed to load image."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        print("IsLoading is false.")
    }
}

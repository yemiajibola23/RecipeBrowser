//
//  InMemoryCache.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/18/25.
//

import UIKit

final class InMemoryCache: ImageCachable {
    private let cache = NSCache<NSString, UIImage>()
    
    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func loadImage(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    func containsImage(for url: URL) -> Bool {
        return cache.object(forKey: url.absoluteString as NSString) != nil
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

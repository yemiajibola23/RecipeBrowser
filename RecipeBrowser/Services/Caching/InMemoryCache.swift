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
        let path = cachePath(for: url)
        print("Saving to RAM under name: \(path)")
        cache.setObject(image, forKey: path as NSString)
    }
    
    func loadImage(for url: URL) -> UIImage? {
        cache.object(forKey: cachePath(for: url) as NSString)
    }
    
    func containsImage(for url: URL) -> Bool {
        let path = cachePath(for: url)
        return cache.object(forKey: path as NSString) != nil
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    func cachePath(for url: URL) -> String {
        let pathComponents = url.pathComponents
        guard pathComponents.count > 2 else { return UUID().uuidString }
        
        return pathComponents[pathComponents.count - 2]
    }
}

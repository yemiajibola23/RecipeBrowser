//
//  InMemoryCache.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/18/25.
//

import UIKit

final class InMemoryCache: ImageCachable {
    private let cache = NSCache<NSString, CacheEntry>()
    private let expirationTime: TimeInterval = 24 * 60 * 60
    private let maxCacheSize = 10
    
    var countLimit: Int { cache.countLimit }
    
    func saveImage(_ image: UIImage, for url: URL, dateSaved: Date = Date()) {
        let path = cachePath(for: url)
        
        if cache.countLimit >= maxCacheSize {
            cache.removeObject(forKey: cache.name as NSString)
        }
        
//        print("Saving to RAM under name: \(path)")
        cache.setObject(CacheEntry(image: image, date: dateSaved), forKey: path as NSString)
    }
    
    func loadImage(for url: URL) -> UIImage? {
        let path = cachePath(for: url) 
        if let entry = cache.object(forKey:  path as NSString), Date().timeIntervalSince(entry.date) < expirationTime {
            return entry.image
        } else {
            cache.removeObject(forKey: path as NSString)
            return nil
        }
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

private class  CacheEntry: NSObject {
    let image: UIImage
    let date: Date
    
    init(image: UIImage, date: Date) {
        self.image = image
        self.date = date
    }
}

//
//  DiskCache.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/18/25.
//

import UIKit

final class DiskCache: ImageCachable {
    
    private let fileManager = FileManager.default
    private var cacheDirectory: URL
    
    init() {
        let cachesFolder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesFolder.appending(path: "ImageCache", directoryHint: .isDirectory)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path()) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func cachePath(for url: URL) -> String {
        let pathComponents = url.pathComponents
        guard pathComponents.count > 2 else { return UUID().uuidString }
        
        return pathComponents[pathComponents.count - 2]
    }
    
    private func cacheURL(for url: URL) -> URL { cacheDirectory.appending(component: cachePath(for: url)) }
    
    func saveImage(_ image: UIImage, for url: URL) {
        guard let imageData = image.pngData() else { return }
        
        try? imageData.write(to: cacheURL(for: url))
    }
    
    func loadImage(for url: URL) -> UIImage? {
        let path = cacheURL(for: url)
        
        return UIImage(contentsOfFile: path.path())
    }
    
    func containsImage(for url: URL) -> Bool {
        return fileManager.fileExists(atPath: cacheURL(for: url).path())
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}

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
    
    private func cachePath(for url: URL) -> URL {
        let fileName = url.lastPathComponent
        return cacheDirectory.appending(component: fileName)
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        guard let imageData = image.pngData() else { return }
        try? imageData.write(to: cachePath(for: url))
    }
    
    func loadImage(for url: URL) -> UIImage? {
        let path = cachePath(for: url)
        
        return UIImage(contentsOfFile: path.path())
    }
    
    func containsImage(for url: URL) -> Bool {
        return fileManager.fileExists(atPath: cachePath(for: url).path())
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}

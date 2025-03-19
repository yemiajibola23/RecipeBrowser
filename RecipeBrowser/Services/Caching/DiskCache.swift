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
    private let expirationTime: TimeInterval = 24 * 60 * 60
    private let maxCacheSize = 50 * 1024 * 1024
    
    init() {
        let cachesFolder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesFolder.appending(path: "ImageCache", directoryHint: .isDirectory)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path()) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        removeExpiredFiles()
    }
    
    func cachePath(for url: URL) -> String {
        let pathComponents = url.pathComponents
        guard pathComponents.count > 2 else { return UUID().uuidString }
        
        return pathComponents[pathComponents.count - 2]
    }
    
    private func cacheURL(for url: URL) -> URL { cacheDirectory.appending(component: cachePath(for: url)) }
    
    func saveImage(_ image: UIImage, for url: URL, dateSaved: Date = Date()) {
        let fileURL = cacheURL(for: url)
        if let imageData = image.pngData() {
            try? imageData.write(to: fileURL)
            setExpirationDate(for: fileURL, savedDate: dateSaved)
            enforceStorageLimit()
        }
    }
    
    func loadImage(for url: URL) -> UIImage? {
        let path = cacheURL(for: url)
        
        removeExpiredFiles()
        
        return UIImage(contentsOfFile: path.path())
    }
    
    func containsImage(for url: URL) -> Bool {
        return fileManager.fileExists(atPath: cacheURL(for: url).path())
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func setExpirationDate(for fileURL: URL, savedDate: Date = Date()) {
        let attributes = [FileAttributeKey.modificationDate: savedDate]
        
        try? fileManager.setAttributes(attributes, ofItemAtPath: fileURL.path())
    }
    
    private func removeExpiredFiles() {
        let expirationDate = Date().addingTimeInterval(-expirationTime)
        print("Expiration date calculated at: \(expirationDate)")
        
        if let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey]) {
            for file in files {
                print("👀 Looking into file: \(file.absoluteString)")
                if let attributes = try? file.resourceValues(forKeys: [.contentModificationDateKey]),
                   let modifiedDate = attributes.contentModificationDate,
                   modifiedDate < expirationDate {
                    print("Removing file at url: \(file.absoluteString)")
                    try? fileManager.removeItem(at: file)
                }
            }
        }
    }
    
    private func enforceStorageLimit() {
        var totalSize: Int = 0
        var files: [(url: URL, size: Int)] = []
        
        if let fileURLs = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) {
            for fileURL in fileURLs {
                if let attributes = try? fileURL.resourceValues(forKeys: [.fileSizeKey]), let size = attributes.fileSize {
                    totalSize += size
                    files.append((url: fileURL, size: size))
                }
            }
        }
        
        files.sort { $0.size > $1.size }
        
        while totalSize > maxCacheSize, let fileToRemove = files.popLast() {
            try? fileManager.removeItem(at: fileToRemove.url)
            
            totalSize -= fileToRemove.size
        }
    }
    
    // Testing metnods
    func cleanupExpiredImages() {
        removeExpiredFiles()
    }
    
    func fileModificationDate(for url: URL) -> Date? {
        let fileURL = cacheURL(for: url)
        let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path)
        return attributes?[.modificationDate] as? Date
    }
}

//
//  ImageCacheManager.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit

protocol ImageCacheProtocol {
    func loadImage(from url: URL) async throws -> UIImage?
    func clearCache()
}

class ImageCacheManager {
    private let diskCache: ImageCachable
    private let memoryCache: ImageCachable
    private let downloader: ImageDownloadable
    
    init(diskCache: ImageCachable, memoryCache: ImageCachable, downloader: ImageDownloadable) {
        self.diskCache = diskCache
        self.memoryCache = memoryCache
        self.downloader = downloader
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        if let memoryImage = memoryCache.loadImage(for: url) {
            return memoryImage
        } else if let diskImage = diskCache.loadImage(for: url) {
            return diskImage
        } else {
            do {
                let image = try await downloader.fetchImage(from: url)
                if let downloadedImage = image {
                    memoryCache.saveImage(downloadedImage, for: url)
                    diskCache.saveImage(downloadedImage, for: url)
                }
                
                return image
            }
        }
    }
    
    func clearCache() {
        memoryCache.clearCache()
        diskCache.clearCache()
    }
}

//
//  ImageManager.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit
import SwiftUI

protocol ImageManagerProtocol: AnyObject {
    func getCachedImage(for url: URL) -> UIImage?
    func loadImage(from url: URL) async throws -> UIImage?
    func clearCache()
}

class ImageManager: ImageManagerProtocol {
    private let diskCache: ImageCachable
    private let memoryCache: ImageCachable
    private let downloader: ImageDownloadable
    
    static var emptyImage: Image { Image(systemName: "tray") }
    static var reloadImage: Image { Image(systemName: "arrow.clockwise.circle.fill") }
    static var placeholderImage: Image { Image(uiImage: UIImage(imageLiteralResourceName: "placeholder-meal")) }
    static var linkImage: Image { Image(systemName: "safari") }
    
    init(diskCache: ImageCachable, memoryCache: ImageCachable, downloader: ImageDownloadable) {
        self.diskCache = diskCache
        self.memoryCache = memoryCache
        self.downloader = downloader
    }
    
    func getCachedImage(for url: URL) -> UIImage? {
        if let memoryImage = memoryCache.loadImage(for: url) {
            print("✅ Returning ram cached image for: \(url.absoluteString)")
            return memoryImage
        } else if let diskImage = diskCache.loadImage(for: url) {
            print("✅ Returning disk cached image for: \(url.absoluteString)")
            return diskImage
        } else { return nil }
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        print("🟡 Attempting to fetch image from: \(url.absoluteString)")
        if let cachedImage = getCachedImage(for: url) {
            return cachedImage
        } else {
            do {
                let image = try await downloader.fetchImage(from: url)
                if let downloadedImage = image {
                    memoryCache.saveImage(downloadedImage, for: url, dateSaved: Date())
                    diskCache.saveImage(downloadedImage, for: url, dateSaved: Date())
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


//
//  ImageManager.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit
import SwiftUI

protocol ImageManagerProtocol: AnyObject {
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
    
    init(diskCache: ImageCachable, memoryCache: ImageCachable, downloader: ImageDownloadable) {
        self.diskCache = diskCache
        self.memoryCache = memoryCache
        self.downloader = downloader
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        print("🟡 Attempting to fetch image from: \(url.absoluteString)")
        if let memoryImage = memoryCache.loadImage(for: url) {
            print("✅ Returning ram cached image for: \(url.absoluteString)")
            return memoryImage
        } else if let diskImage = diskCache.loadImage(for: url) {
            print("✅ Returning disk cached image for: \(url.absoluteString)")
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


//
//  ImageCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Yemi Ajibola  on 2/18/25.
//

import XCTest
import Foundation
@testable import RecipeBrowser

class ImageCacheManager {
    let diskCache: ImageCachable
    let memoryCache: ImageCachable
    let downloader: ImageDownloadable
    
    init(diskCache: ImageCachable, memoryCache: ImageCachable, downloader: ImageDownloadable) {
        self.diskCache = diskCache
        self.memoryCache = memoryCache
        self.downloader = downloader
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        if let memoryImage = memoryCache.loadImage(for: url) {
            return memoryImage
        } else {
            do {
                let image = try await downloader.fetchImage(from: url)
                if let downloadedImage = image {
                    memoryCache.saveImage(downloadedImage, for: url)
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


final class ImageCacheManagerTests: XCTestCase {

    func testImageCacheDownloadsImageIfNotInRAMorDisk() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!

        let mockDownloader = MockImageDownloader()
        mockDownloader.mockImage = expectedImage
        
        let sut = makeSUT(mockDownloader: mockDownloader)
        
        // When
        let downloadedImage = try? await sut.loadImage(from: testURL)
        XCTAssertNotNil(downloadedImage, "Image should be downloaded since not in cache.")
    }
    
    func testImageCacheManagerLoadsImageFromRAM() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        
        // Memory cache has image
        let memoryCache = MockInMemoryCache()
        memoryCache.image = expectedImage
        
        let sut = makeSUT(memoryCache: memoryCache)
        
        // When
        let retrievedImage = try? await sut.loadImage(from: testURL)
        
        XCTAssertNotNil(retrievedImage)
    }
}


private extension ImageCacheManagerTests {
    func makeSUT(diskCache: MockDiskCache = MockDiskCache(),
                 memoryCache: MockInMemoryCache = MockInMemoryCache(),
                 mockDownloader: MockImageDownloader = MockImageDownloader()) -> ImageCacheManager {
        ImageCacheManager(diskCache: diskCache,
                          memoryCache: memoryCache,
                          downloader: mockDownloader)
    }
    
    class MockImageDownloader: ImageDownloadable {
        var mockImage: UIImage?
        var mockError: Error?
        
        func fetchImage(from url: URL) async throws -> UIImage? {
            if let error = mockError {
                throw error
            }
            
            guard let image = mockImage else {
                throw ImageDownloader.Error.imageDecodeFailure
            }
            
            return image
        }
    }
    
    class MockInMemoryCache: ImageCachable {
        var image: UIImage?
        
        init(image: UIImage? = nil) {
            self.image = image
        }
        
        func saveImage(_ image: UIImage, for url: URL) {
            self.image = image
        }
        
        func loadImage(for url: URL) -> UIImage? { image }
        
        func containsImage(for url: URL) -> Bool { image != nil }
        
        func clearCache() {}
    }
    
    class MockDiskCache: ImageCachable {
        var image: UIImage?
        
        init(image: UIImage? = nil) {
            self.image = image
        }
        
        func saveImage(_ image: UIImage, for url: URL) {
            self.image = image
        }
        
        func loadImage(for url: URL) -> UIImage? { image }
        
        func containsImage(for url: URL) -> Bool { image != nil }
        
        func clearCache() {}
    }
}

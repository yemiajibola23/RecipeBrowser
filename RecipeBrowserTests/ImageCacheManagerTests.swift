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


final class ImageCacheManagerTests: XCTestCase {
    fileprivate var memoryCache: MockInMemoryCache?
    fileprivate var diskCache: MockDiskCache?
    
    var sut: ImageCacheManager?
    
    override func tearDown() {
        sut?.clearCache()
    }
    
    func testImageCacheDownloadsImageIfNotInRAMorDisk() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!

        let mockDownloader = MockImageDownloader()
        mockDownloader.mockImage = expectedImage
        
        sut = makeSUT(mockDownloader: mockDownloader)
        
        // When
        let downloadedImage = try? await sut?.loadImage(from: testURL)
        XCTAssertNotNil(downloadedImage, "Image should be downloaded since not in cache.")
    }
    
    func testImageCacheManagerLoadsImageFromRAM() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        
        // Memory cache has image
        let memoryCache = MockInMemoryCache()
        memoryCache.image = expectedImage
        
        sut = makeSUT(memoryCache: memoryCache)
        
        // When
        let memoryImage = try? await sut?.loadImage(from: testURL)
        XCTAssertNotNil(memoryImage)
    }
    
    func testImageCacheManagerLoadsImageFromDiskIfNotInRAM() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        
        // Memory cache has image
        let mockDiskCache = MockDiskCache()
        mockDiskCache.image = expectedImage
        
        sut = makeSUT(diskCache: mockDiskCache)
        
        // When
        let diskImage = try? await sut?.loadImage(from: testURL)
        XCTAssertNotNil(diskImage)
    }
    
    func testImageCacheManagerSavesImageInRAMOrDiskIfDownloaded() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!

        let mockDownloader = MockImageDownloader()
        mockDownloader.mockImage = expectedImage
        
        sut = makeSUT(mockDownloader: mockDownloader)
        
        // When
       _ = try? await sut?.loadImage(from: testURL)
        
        mockDownloader.mockImage = nil
        
        let cachedImage = try? await sut?.loadImage(from: testURL)
        
        // Then
        XCTAssertEqual(diskCache?.image, cachedImage)
        XCTAssertEqual(memoryCache?.image, cachedImage)
    }
}


private extension ImageCacheManagerTests {
    func makeSUT(diskCache: MockDiskCache = MockDiskCache(),
                 memoryCache: MockInMemoryCache = MockInMemoryCache(),
                 mockDownloader: MockImageDownloader = MockImageDownloader()) -> ImageCacheManager {
        self.diskCache = diskCache
        self.memoryCache = memoryCache
        return ImageCacheManager(diskCache: diskCache,
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
        
        func clearCache() {
            image = nil
        }
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
        
        func clearCache() {
            image = nil
        }
    }
}

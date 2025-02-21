//
//  ImageCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Yemi Ajibola  on 2/18/25.
//

import XCTest
import Foundation
@testable import RecipeBrowser

final class ImageCacheManagerTests: XCTestCase {
    fileprivate var memoryCache: MockInMemoryCache?
    fileprivate var diskCache: MockDiskCache?
    
    var sut: ImageCacheManager?
    
    override func tearDown() {
        sut?.clearCache()
    }
    
    func testImageCacheManagerLoadsImageFromRAM() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        
        // Memory cache has image
        let memoryCache = MockInMemoryCache()
        memoryCache.mockImage = expectedImage
        
        sut = makeSUT(memoryCache: memoryCache)
        
        // When
        let memoryImage = try? await sut?.loadImage(from: testURL())
        XCTAssertNotNil(memoryImage)
    }
    
    func testImageCacheManagerLoadsImageFromDiskIfNotInRAM() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        
        // Memory cache has image
        let mockDiskCache = MockDiskCache()
        mockDiskCache.mockImage = expectedImage
        
        sut = makeSUT(diskCache: mockDiskCache)
        
        // When
        let diskImage = try? await sut?.loadImage(from: testURL())
        XCTAssertNotNil(diskImage)
    }
    
    func testImageCacheDownloadsImageIfNotInRAMorDisk() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!

        let mockDownloader = MockImageDownloader()
        mockDownloader.mockImage = expectedImage
        
        sut = makeSUT(mockDownloader: mockDownloader)
        
        // When
        let downloadedImage = try? await sut?.loadImage(from: testURL())
        XCTAssertNotNil(downloadedImage, "Image should be downloaded since not in cache.")
    }
    
    func testImageCacheManagerSavesImageInRAMOrDiskIfDownloaded() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!

        let mockDownloader = MockImageDownloader()
        mockDownloader.mockImage = expectedImage
        
        sut = makeSUT(mockDownloader: mockDownloader)
        
        // When
       _ = try? await sut?.loadImage(from: testURL())
        
        mockDownloader.mockImage = nil
        
        let cachedImage = try? await sut?.loadImage(from: testURL())
        
        // Then
        XCTAssertEqual(diskCache?.mockImage, cachedImage)
        XCTAssertEqual(memoryCache?.mockImage, cachedImage)
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
                throw ImageDownloader.Error.imageDecoding
            }
            
            return image
        }
    }
    
    class MockInMemoryCache: ImageCachable {
        var mockImage: UIImage?
        
        init(image: UIImage? = nil) {
            self.mockImage = image
        }
        
        func saveImage(_ image: UIImage, for url: URL) {
            self.mockImage = image
        }
        
        func loadImage(for url: URL) -> UIImage? { mockImage }
        
        func containsImage(for url: URL) -> Bool { mockImage != nil }
        
        func clearCache() {
            mockImage = nil
        }
    }
    
    class MockDiskCache: ImageCachable {
        var mockImage: UIImage?
        
        init(image: UIImage? = nil) {
            self.mockImage = image
        }
        
        func saveImage(_ image: UIImage, for url: URL) {
            self.mockImage = image
        }
        
        func loadImage(for url: URL) -> UIImage? { mockImage }
        
        func containsImage(for url: URL) -> Bool { mockImage != nil }
        
        func clearCache() {
            mockImage = nil
        }
    }
}

//
//  ImageViewModelTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import XCTest
@testable import RecipeBrowser

class ImageViewModel {
    private var cacheManager: ImageCacheProtocol
    var image: UIImage?
    var isLoading = false
    var errorMessage: String?
    
    init(cacheManager: ImageCacheProtocol) {
        self.cacheManager = cacheManager
    }
    
    func loadImage(from url: URL) async {
        guard let fetchedImage = try? await cacheManager.loadImage(from: url) else { return }
        
        image = fetchedImage
    }
}

final class ImageViewModelTests: XCTestCase {
    
    func testImageViewModelLoadImagesUpdatesImageOnSuccess() async {
        // Given
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let expectedImage = UIImage(systemName: "star")!
        let mockCacheManager = MockImageCacheManager()
        mockCacheManager.mockImage = expectedImage
        
        let sut = ImageViewModel(cacheManager: mockCacheManager)
        
        // When
        await sut.loadImage(from: testURL)
        
        // Then
        XCTAssertNotNil(sut.image, "View model should have image afer loading image.")
        XCTAssertEqual(sut.image?.pngData()!, expectedImage.pngData()!, "Loaded image should match expected image.")
        
    }
}

private extension ImageViewModelTests {
    class MockImageCacheManager: ImageCacheProtocol {
        var mockImage: UIImage?
        
        func loadImage(from url: URL) async throws -> UIImage? { mockImage }
        
        func clearCache() { mockImage = nil }
    }
}

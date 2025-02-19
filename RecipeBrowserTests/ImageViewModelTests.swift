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
        do {
            let fetchedImage = try await cacheManager.loadImage(from: url)
            image = fetchedImage
        } catch {
            errorMessage = error.localizedDescription
        }
        
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
    
    func testImageViewModelSetsErrorMessageOnFailure() async {
        // Given
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let expectedError = NSError(domain: "any", code: 0)
        let mockCacheManager = MockImageCacheManager()
        mockCacheManager.mockError = expectedError
        
        let sut = ImageViewModel(cacheManager: mockCacheManager)
        
        // When
        await sut.loadImage(from: testURL)
        
        // Then
        XCTAssertNil(sut.image, "View model should not have image afer loading image with error.")
        XCTAssertNotNil(sut.errorMessage, " View model should have error message. ")
        
    }
}

private extension ImageViewModelTests {
    class MockImageCacheManager: ImageCacheProtocol {
        var mockImage: UIImage?
        var mockError: Error?
        
        func loadImage(from url: URL) async throws -> UIImage? {
            if let error = mockError { throw error }
            return mockImage
        }
        
        func clearCache() { mockImage = nil }
    }
}

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
        isLoading = true
        print("is Loading is true.")
        errorMessage = nil
        
        do {
            if let fetchedImage = try await cacheManager.loadImage(from: url) {
                image = fetchedImage
            } else {
                errorMessage = "Failed to load image."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        print("IsLoading is false.")
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
        XCTAssertNotNil(sut.errorMessage, "View model should have error message. ")
    }
    
        func testImageViewModelIsLoadingStateChange() async {
            // Given
            let testURL = URL(string: "https://test.com/sample.jpg")!
            let expectedImage = UIImage(systemName: "star")!
            let mockCacheManager = MockImageCacheManager()
            mockCacheManager.mockImage = expectedImage
            let expectation = expectation(description: "Expected to load image.")
            
            let sut = ImageViewModel(cacheManager: mockCacheManager)
            
            // when
            Task {
                await sut.loadImage(from: testURL)
                expectation.fulfill()
            }
            
            await waitForCondition(timeout: 0.2) { sut.isLoading }
            
            XCTAssertTrue(sut.isLoading, "isLoading should be true while image is loading.")
            
            await fulfillment(of: [expectation], timeout: 1.0)
            
            XCTAssertFalse(sut.isLoading, "isLoading should be false after loading is finished.")
            
        }
}

private extension ImageViewModelTests {
    func waitForCondition(timeout: TimeInterval, condition: @escaping () -> Bool) async {
        let startTime = Date()

        while Date().timeIntervalSince(startTime) < timeout {
            if condition() { return }
            try? await Task.sleep(nanoseconds: 100_000_000) // Sleep for 0.1 seconds
        }

        XCTFail("Condition not met within \(timeout) seconds")
    }

    
    class MockImageCacheManager: ImageCacheProtocol {
        var mockImage: UIImage?
        var mockError: Error?
        
        func loadImage(from url: URL) async throws -> UIImage? {
            if let error = mockError { throw error }
            try? await Task.sleep(nanoseconds: 500_000_000)
            return mockImage
        }
        
        func clearCache() { mockImage = nil }
    }
}

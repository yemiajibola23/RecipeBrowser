//
//  ImageViewModelTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import XCTest
@testable import RecipeBrowser

final class RecipeItemViewModelTests: XCTestCase {
    
    func testImageViewModelLoadImagesUpdatesImageOnSuccess() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let mockCacheManager = MockImageCacheManager()
        mockCacheManager.mockImage = expectedImage
        
        let sut = makeSUT(url: testURL(), cacheManager: mockCacheManager)
        // When
        await sut.loadImage()
        
        // Then
        XCTAssertNotNil(sut.image, "View model should have image afer loading image.")
        XCTAssertEqual(sut.image?.pngData()!, expectedImage.pngData()!, "Loaded image should match expected image.")
        
    }
    
    func testImageViewModelSetsErrorMessageOnFailure() async {
        // Given
        let expectedError = NSError(domain: "any", code: 0)
        let mockCacheManager = MockImageCacheManager()
        mockCacheManager.mockError = expectedError
        
        let sut = makeSUT(url: testURL(), cacheManager: mockCacheManager)

        // When
        await sut.loadImage()
        
        // Then
        XCTAssertNil(sut.image, "View model should not have image afer loading image with error.")
        XCTAssertNotNil(sut.errorMessage, "View model should have error message. ")
    }
    
        func testImageViewModelIsLoadingStateChange() async {
            // Given
            let expectedImage = UIImage(systemName: "star")!
            let mockCacheManager = MockImageCacheManager()
            mockCacheManager.mockImage = expectedImage
            let expectation = expectation(description: "Expected to load image.")
            
            let sut = makeSUT(url: testURL(), cacheManager: mockCacheManager)
            
            // when
            Task {
                await sut.loadImage()
                expectation.fulfill()
            }
            
            await waitForCondition(timeout: 0.2) { sut.isLoading }
            
            XCTAssertTrue(sut.isLoading, "isLoading should be true while image is loading.")
            
            await fulfillment(of: [expectation], timeout: 1.0)
            
            XCTAssertFalse(sut.isLoading, "isLoading should be false after loading is finished.")
            
        }
}

private extension RecipeItemViewModelTests {
    func makeSUT(url: URL, cacheManager: MockImageCacheManager) -> RecipeItemViewModel {
        RecipeItemViewModel(recipe: Recipe.mock.first!, cacheManager: cacheManager)
    }
    
    func waitForCondition(timeout: TimeInterval, condition: @escaping () -> Bool) async {
        let startTime = Date()

        while Date().timeIntervalSince(startTime) < timeout {
            if condition() { return }
            try? await Task.sleep(nanoseconds: 100_000_000) // Sleep for 0.1 seconds
        }

        XCTFail("Condition not met within \(timeout) seconds")
    }
}

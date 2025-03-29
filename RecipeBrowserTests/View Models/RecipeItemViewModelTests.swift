//
//  ImageViewModelTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import XCTest
@testable import RecipeBrowser

final class RecipeViewModelTests: XCTestCase {
    
    func testRecipeItemiewModelLoadSmallImageUpdatesSmallImageOnSuccess() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
       
        await assert(expectedImage: expectedImage, load: { await $0.loadSmallImage() }, imageKeyPath: \.smallImage, loadingFlagKeyPath: \.isLoadingSmallImage)
    }
    
    
    func testRecipeItemiewModelLoadLargeImageUpdatesLargeImageOnSuccess() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
       
        await assert(expectedImage: expectedImage, load: { await $0.loadLargeImage() }, imageKeyPath: \.largeImage, loadingFlagKeyPath: \.isLoadingLargeImage)
    }
    
    func testRecipeViewModelLoadSmallImageSetsErrorMessageOnFailure() async {
        await assert(load: { await $0.loadSmallImage() }, imageKeyPath: \.smallImage, expectedErrorMessage: "Failed to load image.")
    }
    
    func testRecipeViewModelLoadLargeImageSetsErrorMessageOnFailure() async {
        await assert(load: { await $0.loadLargeImage() }, imageKeyPath: \.largeImage, expectedErrorMessage: "Failed to load image.")
    }
    
}

private extension RecipeViewModelTests {
    func makeSUT(url: URL, imageManager: MockImageManager) -> RecipeViewModel {
        RecipeViewModel(recipe: Recipe.mock.first!, imageManager: imageManager)
    }
    
    func assert( load: @escaping (RecipeViewModel) async -> Void,
        imageKeyPath: KeyPath<RecipeViewModel, UIImage?>,
        expectedErrorMessage: String = "This operation could not be completed",
        file: StaticString = #file,
        line: UInt = #line) async {
        let mockImageManager = MockImageManager()
        mockImageManager.mockError = URLError(.badServerResponse)
        

        // When
            let sut = makeSUT(url: testURL(), imageManager: mockImageManager)
            await load(sut)
        
        // Then
            XCTAssertNil(sut[keyPath: imageKeyPath], "View model should not have image afer loading image with error.")
        XCTAssertNotNil(sut.errorMessage, expectedErrorMessage)
    }
    
    func assert(expectedImage: UIImage,
                load: @escaping (RecipeViewModel) async -> Void,
                imageKeyPath: KeyPath<RecipeViewModel, UIImage?>,
                loadingFlagKeyPath: KeyPath<RecipeViewModel, Bool>,
                file: StaticString = #file,
                line: UInt = #line) async {
        let mockImageManager = MockImageManager()
        mockImageManager.mockImage = expectedImage
        
        let sut = makeSUT(url: testURL(), imageManager: mockImageManager)
        // When
        let expectation = expectation(description: "Image loading completion")
        
        Task {
            await load(sut)
            expectation.fulfill()
        }
        await waitForCondition(timeout: 0.2) { sut[keyPath: loadingFlagKeyPath] }
        XCTAssertTrue(sut[keyPath: loadingFlagKeyPath], "Expected loading flag to be true.", file: file, line: line)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(sut[keyPath: imageKeyPath]?.pngData(), expectedImage.pngData(), file: file, line: line)
        XCTAssertFalse(sut[keyPath: loadingFlagKeyPath], "Expected loading flag to be false.", file: file, line: line)
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

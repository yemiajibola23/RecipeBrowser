//
//  InMemoryCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest
@testable import RecipeBrowser

final class InMemoryCacheTests: XCTestCase {
    var sut: InMemoryCache!
    let sampleImage = UIImage(systemName: "star")!
    
    override func setUp() {
        // Given
        sut = InMemoryCache()
    }
    
    override func tearDown() {
        sut?.clearCache()
    }
    
    func testInMemoryCacheSavesImageSuccessfully() {
        // given
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        
        // when
        sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in memory cache.")
    }
    
    func testInMemoryCacheLoadsImageSuccessfully() {
        // given
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        sut.saveImage(sampleImage, for: testURL)
        
        // when
        let retrievedImage = sut.loadImage(for: testURL)
        
        // then
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData(),  "Retrieved image from memory should match the original image.")
    }
    
    func testInMemoryCacheDeletesImagesIfOlderThanCacheExpirationDate() {
        // Given
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let expirationTime: Double = 24 * 60 * 60
        let oldDate = Date().addingTimeInterval(-expirationTime - 1)
        sut.saveImage(sampleImage, for: testURL, dateSaved: oldDate)
        
        // When
        let expiredImage = sut.loadImage(for: testURL)
       
        // Then
        XCTAssertNil(expiredImage, "Expired image should be removed")
    }
    
    func testInMemoryCacheEnforcesStorageLimit() {
        // Given
        for i in 1...15 {
            let url = URL(string: "https://example.com/image/\(i)/small.jpg")!
            // When
            sut.saveImage(sampleImage, for: url)
        }
        
        // Then
        XCTAssertLessThanOrEqual(sut.countLimit, 10)
    }
}

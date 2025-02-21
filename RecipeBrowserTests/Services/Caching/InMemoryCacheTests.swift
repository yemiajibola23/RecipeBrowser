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
        let testURL = testURL()
        // when
        sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in memory cache.")
    }
    
    func testInMemoryCacheLoadsImageSuccessfully() {
        // given
        sut.saveImage(sampleImage, for: testURL())
        
        // when
        let retrievedImage = sut.loadImage(for: testURL())
        
        // then
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData(),  "Retrieved image from memory should match the original image.")
    }

}

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
    
    override func tearDown() {
        sut?.clearCache()
    }
    
    func testInMemoryCacheSavesImageSuccessfully() {
        // given
        let sampleImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        sut = InMemoryCache()
        
        // when
        sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in memory cache.")
    }
    
    func testInMemoryCacheLoadsImageSuccessfully() {
        // given
        let sampleImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        sut = InMemoryCache()
        sut.saveImage(sampleImage, for: testURL)
        
        // when
        let retrievedImage = sut.loadImage(for: testURL)
        
        // then
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData())
    }

}

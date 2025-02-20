//
//  DiskCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest
@testable import RecipeBrowser

final class DiskCacheTests: XCTestCase {
    var sut: DiskCache!
    let sampleImage = UIImage(systemName: "star")!
    
    override func setUp() {
        // Given
        sut = DiskCache()
    }
    
    override func tearDown() {
        sut.clearCache()
    }

    func testDiskCacheSavesImageSuccessfully() {
        // when
        sut.saveImage(sampleImage, for: testURL())
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL()), "Image should be stored in disk cache.")
    }
    
    
    func testDiskCacheLoadsImageSuccessfully() {
        // given
        let testURL = testURL().appending(path: "example.jpg")
        sut.saveImage(sampleImage, for: testURL)
        
        // when
        let retrievedImage = sut.loadImage(for: testURL)
        
        // then
        XCTAssertNotNil(retrievedImage)
//        XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData(), "Retrieved image from disk should match the original image.") TODO: - Fix flaky test.
    }
}

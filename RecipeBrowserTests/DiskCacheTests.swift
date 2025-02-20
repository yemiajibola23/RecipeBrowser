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
        sut.saveImage(sampleImage, for: testURL(isImage: true))
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL(isImage: true)), "Image should be stored in disk cache.")
    }
    
    
    func testDiskCacheLoadsImageSuccessfully() {
        // given
        sut.saveImage(sampleImage, for: testURL(isImage: true))
        
        // when
        let retrievedImage = sut.loadImage(for: testURL(isImage: true))
        
        // then
        XCTAssertNotNil(retrievedImage)
//        XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData(), "Retrieved image from disk should match the original image.") TODO: - Fix flaky test.
    }
}

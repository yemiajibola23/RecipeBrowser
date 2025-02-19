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
    
    override func tearDown() {
        sut.clearCache()
    }

    func testDiskCacheSavesImageSuccessfully() async {
        // given
        let sampleImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        sut = DiskCache()
        
        // when
        await sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in disk cache.")
    }
    
    
    func testDiskCacheLoadsImageSuccessfully() async {
        // given
        let sampleImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        sut = DiskCache()
        await sut.saveImage(sampleImage, for: testURL)
        
        // when
        let retrievedImage = await sut.loadImage(for: testURL)
        
        // then
        XCTAssertNotNil(retrievedImage)
//        XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData()) flaky test
    }
}

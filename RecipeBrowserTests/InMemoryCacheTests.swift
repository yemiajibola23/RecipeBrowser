//
//  InMemoryCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest

class InMemoryCache {
    private let cache = NSCache<NSString, UIImage>()
    
    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func containsImage(for url: URL) -> Bool {
        return cache.object(forKey: url.absoluteString as NSString) != nil
    }
}

final class InMemoryCacheTests: XCTestCase {
    
    func testInMemoryCacheSavesImageSuccessfully() {
        // given
        let sampleImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let sut = InMemoryCache()
        
        // when
        sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in memory cache.")
    }
}

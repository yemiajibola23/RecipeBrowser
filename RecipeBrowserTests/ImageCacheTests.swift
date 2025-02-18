//
//  ImageCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Yemi Ajibola  on 2/18/25.
//

import XCTest
import Foundation

class ImageCache {
    let cacheDirectory: URL?
    
    init() {
        let cachesFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesFolder.appending(path: "ImageCache", directoryHint: .isDirectory)
    }
}


final class ImageCacheTests: XCTestCase {

    func testInitCreatesCacheDirectory()  {
        // when
        let sut = ImageCache()
        
        // then
        XCTAssertNotNil(sut.cacheDirectory)
    }
}

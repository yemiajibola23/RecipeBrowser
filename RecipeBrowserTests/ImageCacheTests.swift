//
//  ImageCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/17/25.
//

import Testing
import Foundation

class ImageCache {
    var cacheDirectory: URL?
    
    init() {
        let cacheFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cacheFolder.appending(component: "ImageCache", directoryHint: .isDirectory)
    }
}


struct ImageCacheTests {

    @Test("Initialization of image cache creates cache directory if it doesn't exist.")
    func initializationCreatesCacheDirectory()  {
        // given
        // when
        let sut = ImageCache()
        
        // then
        #expect(sut.cacheDirectory != nil)
    }

}

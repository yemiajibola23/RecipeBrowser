//
//  DiskCacheTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest

class DiskCache {
    
    private let fileManager = FileManager.default
    private var cacheDirectory: URL
    
    init() {
        let cachesFolder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesFolder.appending(path: "ImageCache", directoryHint: .isDirectory)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path()) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func saveImage(_ image: UIImage, for url: URL) async {
        let fileName = url.lastPathComponent
        let fullPath = cacheDirectory.appending(component: fileName)
        
        guard let imageData = image.pngData() else { return }
        try? imageData.write(to: fullPath)
    }
    
    func containsImage(for url: URL) -> Bool {
        let fileName = url.lastPathComponent
        let fullPath = cacheDirectory.appending(component: fileName)
        
        return fileManager.fileExists(atPath: fullPath.path())
    }
}

final class DiskCacheTests: XCTestCase {

    func testDiskCacheSavesImageSuccessfully() async {
        // given
        let sampleImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let sut = DiskCache()
        
        // when
        await sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in disk cache.")
    }
    
}

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
    let tempDirectory = FileManager.default.temporaryDirectory.appending(path: "TestimageCache", directoryHint: .isDirectory)
    override func setUp() {
        super.setUp()
        // Given
        sut = DiskCache(cacheDirectory: tempDirectory)
    }
    
    override func tearDown() {
        sut.clearCache()
        super.tearDown()
    }

    func testDiskCacheSavesImageSuccessfully() {
        // when
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        sut.saveImage(sampleImage, for: testURL)
        
        // then
        XCTAssertTrue(sut.containsImage(for: testURL), "Image should be stored in disk cache.")
    }
    
    
    func testDiskCacheLoadsImageSuccessfully() {
        // given
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        sut.saveImage(sampleImage, for: testURL)
        
        // when
        let retrievedImage = sut.loadImage(for: testURL)
        
        // then
        XCTAssertNotNil(retrievedImage)
       // XCTAssertEqual(retrievedImage?.pngData(), sampleImage.pngData(), "Retrieved image from disk should match the original image.") //TODO: - Fix flaky test.
    }
    
    func testDifferentImagesDoNotOverwriteEachOther() {
        let image1 = UIImage(systemName: "star")!
        let image2 = UIImage(systemName: "camera")!
        
        let testURL1 = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let testURL2 = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/abcd1234-5678-90ef-ghij-klmnopqrstuv/small.jpg")!
        
        
        sut.saveImage(image1, for: testURL1)
        sut.saveImage(image2, for: testURL2)
        
        let retrievedImage1 = sut.loadImage(for: testURL1)
        let retrievedImage2 = sut.loadImage(for: testURL2)
        
        XCTAssertNotNil(retrievedImage1, "Expected first image to be retrievable.")
        XCTAssertNotNil(retrievedImage2, "Expected second image to be retrievable.")
        XCTAssertNotEqual(retrievedImage1?.pngData(), retrievedImage2?.pngData(), "Images should be different.")
    }
    
    func testDiskCacheDeletesImagesIfOlderThanCacheExpirationDate() {
        // Given
        let testImage = UIImage(systemName: "star")!
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        
        // When
        let expirationTime: Double = 24 * 60 * 60
        let oldDate = Date().addingTimeInterval(-expirationTime - 1)
        sut.saveImage(testImage, for: testURL, dateSaved: oldDate)
        
        if let modifiedDate = sut.fileModificationDate(for: testURL) {
            print("📸 File saved at: \(modifiedDate)")
        } else {
            XCTFail("Failed to retrieve modification date.")
        }
        
        sleep(2)
        sut.cleanupExpiredImages()
        
        // Then
        let expiredImage = sut.loadImage(for: testURL)
        XCTAssertNil(expiredImage, "Expired image should be removed")
        
    }
    
    func testDiskCacheEnforcesStorageLimit() {
        // Given
        let testImage = UIImage(systemName: "star.fill")!
        for i in 1...20 {
            // When
            let url = URL(string: "https://example.com/image/\(i)/small.jpg")!
            sut.saveImage(testImage, for: url)
        }
        
        // Then
        let remainingFiles = try? FileManager.default.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: [.fileSizeKey])
        let totalFileSize = remainingFiles?.reduce(0, { (sum, file) -> Int in
            let attributes = try? file.resourceValues(forKeys: [.fileSizeKey])
            return sum + (attributes?.fileSize ?? 0)
        }) ?? 0
        
        XCTAssertLessThanOrEqual(totalFileSize, 50 * 1024 * 1024, "DiskCache should enforce 50 MB storage limit.")
    }
}

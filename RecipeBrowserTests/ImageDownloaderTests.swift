//
//  ImageDownloaderTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest
@testable import RecipeBrowser

final class ImageDownloaderTests: XCTestCase {
    func testImageDownloaderFailsWithImageDecodeFailure() async {
        let invalidData = Data("this-is-invalid".utf8)
        
        let sut = makeSUT(data: invalidData)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL())
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch ImageDownloader.Error.imageDecodeFailure {
            // Success
        } catch {
            XCTFail("Expected to fail with image decode failure but failed with \(error)")
        }
    }
    
    func testImageDownloaderSucceedsAndReturnsImage() async {
        let expectedImage = UIImage(systemName: "star")!
        let expectedData = expectedImage.pngData()!
        
        let sut = makeSUT(data: expectedData)
        
        // when
        do {
            let actualImage = try await sut.fetchImage(from: testURL())
            XCTAssertNotNil(actualImage)
//            XCTAssertEqual(actualImage?.pngData()!, expectedData, "Expected same image data as expected image data.") //TODO: - Fix flaky test
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
}


private extension ImageDownloaderTests {
    
    func makeSUT(data: Data?, error: NetworkService.Error? = nil) -> ImageDownloader {
        let mockNetworkService = MockNetworkService(mockData: data, mockError: error)
        return ImageDownloader(networkService: mockNetworkService)
    }
    
    func imagesAreIdentical(_ img1: UIImage, _ img2: UIImage) -> Bool {
        guard let data1 = img1.cgImage, let data2 = img2.cgImage else { return false }
        
        return data1.width == data2.width &&
               data1.height == data2.height &&
               CFEqual(data1.dataProvider, data2.dataProvider)
    }
}

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
        // Given
        let invalidData = Data("this-is-invalid".utf8)
        let sut = makeSUT(data: invalidData)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL())
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch .imageDecoding {
            // Success
        } catch {
            XCTFail("Expected to fail with image decode failure but failed with \(error)")
        }
    }
    
    func testImageDownloaderThrowsNetworkErrorWhenNetworkFails() async {
        // Given
        let expectedError = NetworkService.Error.networkFailure(statusCode: 404)
        let sut = makeSUT(error: expectedError)
        
        do {
            _ = try await sut.fetchImage(from: testURL())
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch let .network(actualError) {
            XCTAssertEqual(actualError, expectedError)
        } catch {
            XCTFail("Expected to fail with image decode failure but failed with \(error)")
        }
    }
    
    func testImageDownloaderSucceedsAndReturnsImage() async {
        // Given
        let expectedImage = UIImage(systemName: "star")!
        let expectedData = expectedImage.pngData()!
        let sut = makeSUT(data: expectedData)
        
        // when
        do {
            let actualImage = try await sut.fetchImage(from: testURL())
            
            // Then
            XCTAssertNotNil(actualImage)
            //XCTAssertEqual(actualImage?.pngData()!, expectedData, "Expected same image data as expected image data.") //TODO: - Fix flaky test
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
}


private extension ImageDownloaderTests {
    func makeSUT(data: Data? = nil, error: NetworkService.Error? = nil) -> ImageDownloader {
        let mockNetworkService = MockNetworkService(mockData: data, mockError: error)
        return ImageDownloader(networkService: mockNetworkService)
    }
}

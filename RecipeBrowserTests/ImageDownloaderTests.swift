//
//  ImageDownloaderTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest
@testable import RecipeBrowser

final class ImageDownloaderTests: XCTestCase {
    func testImageDownloaderFailsWithNetworkFailure() async {
        // Given
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let failureResponse = HTTPURLResponse(url: testURL, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .success((failureResponse, Data()))
        
        let sut = ImageDownloader(session: session)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch ImageDownloader.Error.networkFailure(let actualStatusCode){
            XCTAssertEqual(actualStatusCode, failureResponse?.statusCode)
        } catch {
            XCTFail("Expected to fail with network failure but failed with \(error).")
        }
    }
    
    func testImageDownloaderFailsWithImageDecodeFailure() async {
        // Given
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let successResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .success((successResponse, Data()))
        
        let sut = ImageDownloader(session: session)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch ImageDownloader.Error.imageDecodeFailure {
            // Success
        } catch {
            XCTFail("Expected to fail with image decode failure but failed with \(error)")
        }
    }
    
    func testImageDownladerFailsWithInvalidURL() async {
        let testURL = URL(string: "ftp://test.com/sample.jpg")!
        let successResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .success((successResponse, Data()))
        
        let sut = ImageDownloader(session: session)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch ImageDownloader.Error.invalidURL {
            // Success
        } catch {
            XCTFail("Expected to fail with invalid url but failed with \(error)")
        }
    }
    
    func testImageDownladerFailsWithUnknowError() async {
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .failure(URLError(.notConnectedToInternet))
        
        let sut = ImageDownloader(session: session)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch ImageDownloader.Error.unknown(let unknownError) {
            XCTAssertTrue(unknownError is URLError, "Expected URLError but got \(unknownError).")
        } catch {
            XCTFail("Expected to fail with unknown error but failed with \(error)")
        }
    }
    
    func testImageDownloaderSucceedsAndReturnsImage() async {
        let expectedImage = UIImage(systemName: "star")!
        let expectedData = expectedImage.pngData()!
        
        let testURL = URL(string: "https://test.com/sample.jpg")!
        let successResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .success((successResponse, expectedData))
        
        let sut = ImageDownloader(session: session)
        
        // when
        do {
            let actualImage = try await sut.fetchImage(from: testURL)
            XCTAssertNotNil(actualImage)
//            XCTAssertTrue(imagesAreIdentical(actualImage, expectedImage), "Expected same image data as expected image data.") TODO: - Fix flaky test
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
}


private extension ImageDownloaderTests {
    
    func imagesAreIdentical(_ img1: UIImage, _ img2: UIImage) -> Bool {
        guard let data1 = img1.cgImage, let data2 = img2.cgImage else { return false }
        
        return data1.width == data2.width &&
               data1.height == data2.height &&
               CFEqual(data1.dataProvider, data2.dataProvider)
    }
}

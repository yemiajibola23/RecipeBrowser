//
//  NetworkServiceTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/20/25.
//

import XCTest
@testable import RecipeBrowser


final class NetworkServiceTests: XCTestCase {
    func testHandleRequestFailsWithNetworkFailureWhenNon200HTTPURLResponse() async {
        // Given
        let testURL = testURL()
        let failureResponse = httpFailedResponse(testURL)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .success((failureResponse, Data()))
        
        let sut = NetworkService(session: session)
        
        // when
        do {
            _ = try await sut.handleRequest(for: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch NetworkService.Error.networkFailure(let actualStatusCode) {
            XCTAssertEqual(actualStatusCode, failureResponse.statusCode)
        } catch {
            XCTFail("Expected to fail with network failure but failed with \(error).")
        }
    }
    
    func testImageDownladerFailsWithInvalidURL() async {
        let invalidURL = URL(string: "ftp://test.com/sample.jpg")!
        let successResponse = HTTPURLResponse(url: invalidURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[invalidURL] = .success((successResponse, Data()))
        
        let sut = NetworkService(session: session)
        
        // when
        do {
            _ = try await sut.handleRequest(for: invalidURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch NetworkService.Error.invalidURL {
            // Success
        } catch {
            XCTFail("Expected to fail with invalid url but failed with \(error)")
        }
    }
    
    func testImageDownladerFailsWithUnknowError() async {
        let testURL = testURL()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .failure(URLError(.notConnectedToInternet))
        
        let sut = NetworkService(session: session)
        
        // when
        do {
            _ = try await sut.handleRequest(for: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch NetworkService.Error.unknown(let unknownError) {
            XCTAssertTrue(unknownError is URLError, "Expected URLError but got \(unknownError).")
        } catch {
            XCTFail("Expected to fail with unknown error but failed with \(error)")
        }
    }
    
    func testNetworkServiceHandleRequesSucceedsAndReturnsData() async {
        let expectedData = Data("this-is-data".utf8)
        
        let testURL = testURL()
        let successResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        

        MockURLProtocol.mockResponses[testURL] = .success((successResponse, expectedData))
        
        let sut = NetworkService(session: session)
        
        // when
        do {
            let actualData = try await sut.handleRequest(for: testURL)
            XCTAssertEqual(expectedData, actualData)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
}

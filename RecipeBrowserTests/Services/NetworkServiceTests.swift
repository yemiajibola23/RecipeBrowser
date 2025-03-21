//
//  NetworkServiceTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/20/25.
//

import XCTest
@testable import RecipeBrowser

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testHandleRequestFailsWithNetworkFailureWhenNon200HTTPURLResponse() async {
        // Given
        let testURL = testURL()
        let failureResponse = httpFailedResponse(testURL)
        
        MockURLProtocol.mockResponses[testURL] = .success((failureResponse, Data()))
        
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
    
    func testNetworkServiceHandleRequestFailsWithInvalidURL() async {
        // Given
        let invalidURL = URL(string: "ftp://test.com/sample.jpg")!
        let successResponse = httpSuccessfulResponse(invalidURL)

        MockURLProtocol.mockResponses[invalidURL] = .success((successResponse, Data()))
        
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
        MockURLProtocol.mockResponses[testURL] = .failure(URLError(.notConnectedToInternet))
                
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
        // Given
        let testURL = testURL()
        let expectedData = Data("this-is-data".utf8)
        let successResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)

        MockURLProtocol.mockResponses[testURL] = .success((successResponse, expectedData))
                
        // when
        do {
            let actualData = try await sut.handleRequest(for: testURL)
            XCTAssertEqual(expectedData, actualData)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
    
    func testNetworkServiceSlowResponse() async {
        // Given
        MockURLProtocol.responseDelay = 5.0
        
        let expectedData = Data("this-is-data".utf8)
        
        let testURL = testURL()
        let successResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)

        MockURLProtocol.mockResponses[testURL] = .success((successResponse, expectedData))
                
        // when
        do {
            let actualData = try await sut.handleRequest(for: testURL)
            XCTAssertEqual(expectedData, actualData)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
}

private extension NetworkServiceTests {
    func makeSUT() -> NetworkService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        return NetworkService(session: session)
    }
}

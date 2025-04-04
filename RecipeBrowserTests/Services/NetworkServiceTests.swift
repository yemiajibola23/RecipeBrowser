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
        let statusCodes = [400, 401, 403, 404, 500]
        let testURL = testURL()
        
        // when
        for code in statusCodes {
            let failureResponse = httpFailedResponse(testURL, statusCode: code)
            setMockResponse(for: testURL, response: failureResponse)
            await performRequestAndAssertError(request: { try await self.sut.handleRequest(for: testURL)}, expectedError: .networkFailure(statusCode: code))
        }
    }
    
    func testNetworkServiceHandleRequestFailsWithInvalidURL() async {
        // Given
        let invalidURL = URL(string: "ftp://test.com/sample.jpg")!
        let successResponse = httpSuccessfulResponse(invalidURL)

        MockURLProtocol.mockResponses[invalidURL] = .success((successResponse, Data()))
        
        // when
        await performRequestAndAssertError(request: { try await self.sut.handleRequest(for: invalidURL) }, expectedError: .invalidURL)
    }
    
    func testImageDownladerFailsWithUnknownError() async {
        let testURL = testURL()
        let error = URLError(.notConnectedToInternet)
        setMockResponse(for: testURL, response: httpSuccessfulResponse(), error: error)
        // when
        await performRequestAndAssertError(request: { try await self.sut.handleRequest(for: testURL) }, expectedError: .unknown(error))
        
    }
    
    func testNetworkServiceHandleRequesSucceedsAndReturnsData() async {
        // Given
        let testURL = testURL()
        let expectedData = Data("this-is-data".utf8)
        setMockResponse(for: testURL, response: httpSuccessfulResponse(), data: expectedData)
                
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
        let testURL = testURL()
        let expectedData = Data("this-is-data".utf8)
        setMockResponse(for: testURL, response: httpSuccessfulResponse(), data: expectedData)
                
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
    
    func assertNetworkFailure(statusCode: Int,
                              file: StaticString = #file,
                              line: UInt = #line) async {
        let url = testURL()
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        setMockResponse(for: url, response: response, data: Data())
        
        await performRequestAndAssertError(request: { [weak self] in try await self?.sut.handleRequest(for: url)}, expectedError: .networkFailure(statusCode: statusCode), file: file, line: line)
        
    }
    
    func performRequestAndAssertError<T>(
        request: @escaping () async throws -> T,
        expectedError: NetworkService.Error?,
        file: StaticString = #file,
        line: UInt = #line) async {
            do {
                _ = try await request()
                XCTFail("Expected to fail with but succeeded.", file: file, line: line)
            } catch let error as NetworkService.Error {
                if let expectedError = expectedError {
                    XCTAssertEqual(error, expectedError, "Expected \(expectedError) but got \(error) instead", file: file, line: line)
                } else {
                    XCTFail("Unexpected NetworkService.Error: \(error)", file: file, line: line)
                }
            } catch {
                XCTFail("Unexpected error: \(error)", file: file, line: line)
            }
        }
    
    func setMockResponse(for url: URL, response: HTTPURLResponse?, data: Data? = nil, error: Error? = nil) {
        if let error = error {
            MockURLProtocol.mockResponses[url] = .failure(error)
        } else {
            MockURLProtocol.mockResponses[url] = .success((response, data ?? Data()))
        }
    }
}

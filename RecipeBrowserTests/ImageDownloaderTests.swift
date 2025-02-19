//
//  ImageDownloaderTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/18/25.
//

import XCTest

class ImageDownloader {
    enum Error: Swift.Error {
        case networkFailure
    }
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchImage(from url: URL) async throws(Error) -> UIImage? {
        throw .networkFailure
    }
}


final class ImageDownloaderTests: XCTestCase {

    func testImageDownloaderFailsWithNetworkFailure() async {
        // Given
        let expectedError = ImageDownloader.Error.networkFailure
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        let testURL = URL(string: "https://test.com/sample.jpg")!

        MockURLProtocol.mockResponses[testURL] = .failure(expectedError)
        
        let sut = ImageDownloader(session: session)
        
        // when
        do {
            _ = try await sut.fetchImage(from: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch {
            XCTAssertEqual(error, expectedError)
        }
    }
}


private extension ImageDownloaderTests {
    class MockURLProtocol: URLProtocol {
        static var mockResponses: [URL: Result<Data, Error>] = [:]
        
        override class func canInit(with request: URLRequest) -> Bool { true }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
        
        override func startLoading() {
            if let url = request.url, let response = MockURLProtocol.mockResponses[url] {
                switch response {
                case .success(let data):
                    self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
                    self.client?.urlProtocol(self, didLoad: data)
                case .failure(let error):
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }
            
            self.client?.urlProtocolDidFinishLoading(self)
        }
        
        
        override func stopLoading() {}
        
    }
}

//
//  SharedTestHelpers.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import Foundation
@testable import RecipeBrowser

func testURL(isImage: Bool = false) -> URL {
    let url = URL(string: "https://test.com/")!
    
    return isImage ? url.appending(path: "sample.jpg", directoryHint: .notDirectory) : url
}

class MockURLProtocol: URLProtocol {
    static var mockResponses: [URL: Result<(HTTPURLResponse?, Data), Error>] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        if let url = request.url, let response = MockURLProtocol.mockResponses[url] {
            switch response {
            case .success(let (response, data)):
                self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
            case .failure(let error):
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}


class MockNetworkService: NetworkServiceProtocol {
    var mockResponse: Result<(HTTPURLResponse?, Data), Error>
    
    init(result: Result<(HTTPURLResponse?, Data), Error>) {
        mockResponse = result
    }
    
    func handleRequest(for url: URL) async throws -> Data {
        switch mockResponse {
        case let .success((response, data)):
            guard response?.statusCode == 200 else { throw NSError(domain: "bad response", code: 1) }
            return data
        case let .failure(error): throw error
        }
    }
    
    
}

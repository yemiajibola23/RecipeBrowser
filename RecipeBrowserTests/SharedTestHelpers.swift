//
//  SharedTestHelpers.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import Foundation

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

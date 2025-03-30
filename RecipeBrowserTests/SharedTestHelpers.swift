//
//  SharedTestHelpers.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import Foundation
@testable import RecipeBrowser

func testURL() -> URL {
    URL(string: "https://test.com/")!
}

func httpFailedResponse(_ url: URL = testURL(), statusCode: Int = 404) -> HTTPURLResponse {
    httpURLResponse(url: url, statusCode: statusCode)
}

func httpSuccessfulResponse(_ url: URL = testURL()) -> HTTPURLResponse {
    httpURLResponse(url: url, statusCode: 200)
}

private func httpURLResponse(url: URL, statusCode: Int) -> HTTPURLResponse {
    return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeRecipe(id: UUID = UUID(), name: String, cuisine: String, imageURL: URL = testURL()) -> (Recipe, [String : Any]) {
    (
        Recipe(id: id.uuidString,
               name: name,
               cuisine: Cuisine(rawValue: cuisine.lowercased()) ?? .unknown,
               smallPhotoURL: imageURL.absoluteString),
        [
            "uuid": id.uuidString,
            "name":  name,
            "cuisine": cuisine,
            "photo_url_small": imageURL.absoluteString
        ].compactMapValues { $0 }
    )
}

func makeRecipesJSON(_ items: [[String: Any]]) -> Data {
    let json = ["recipes" : items]
    return try! JSONSerialization.data(withJSONObject: json)
}

class MockURLProtocol: URLProtocol {
    static var responseDelay: TimeInterval = 0
    
    static var mockResponses: [URL: Result<(HTTPURLResponse?, Data), Error>] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        guard let url = request.url else {
            self.client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + MockURLProtocol.responseDelay) {
            if let response = MockURLProtocol.mockResponses[url] {
                switch response {
                case .success(let (hrtpResponse, data)):
                    if let httpResponse = hrtpResponse {
                        self.client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
                    }
                    self.client?.urlProtocol(self, didLoad: data)
                case .failure(let error):
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            } else {
                self.client?.urlProtocol(self, didFailWithError: URLError(.resourceUnavailable))
            }
            
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}


class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    var mockError: NetworkService.Error?
    
    init(mockData: Data? = nil, mockError: NetworkService.Error? = nil) {
        self.mockData = mockData
        self.mockError = mockError
    }
    
    func handleRequest(for url: URL) async throws -> Data {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw NSError(domain: "MockNetworkService", code: 0)
        }
        
        return data
    }
}

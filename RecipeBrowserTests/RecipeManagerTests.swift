//
//  RecipeManagerTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import XCTest
@testable import RecipeBrowser

class RecipeManager {
    enum Error: Swift.Error {
        case unknown
    }
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes(from url: URL) async throws(Error) -> Data {
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            print(error.localizedDescription)
            throw .unknown
        }
       
    }
}

final class RecipeManagerTests: XCTestCase {
    
    func testRecipeManagerFetchRecipesError() async {
        let url =  URL(string: "https://test-url.com/recipes")!
        let expectedData = Data("this is data".utf8)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        let failureResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponses[url] = .failure(RecipeManager.Error.unknown)
        
        let sut = RecipeManager(session: session)

        do {
             _ = try await sut.fetchRecipes(from: url)
            XCTFail("Expected to fail.")
        } catch {
            
            // Success
        }
        
    }
    
    func testRecipeManagerFetchRecipesSucceedsReturnsData() async {
        // Given
        let url =  URL(string: "https://test-url.com/recipes")!
        let expectedData = Data("this is data".utf8)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponses[url] = .success((successResponse, expectedData))
        
        let sut = RecipeManager(session: session)

        // When
        do {
            let actualData = try await sut.fetchRecipes(from: url)
            XCTAssertEqual(actualData, expectedData)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }

}

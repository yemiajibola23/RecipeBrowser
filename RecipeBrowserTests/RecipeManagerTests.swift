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
        case invalidURL
        case networkFailure(statusCode: Int)
    }
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes(from url: URL) async throws(Error) -> Data {
        guard url.scheme == "http" || url.scheme == "https" else {
            throw Error.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw Error.networkFailure(statusCode: 0) }
            
            guard httpResponse.statusCode == 200 else {
                throw Error.networkFailure(statusCode: httpResponse.statusCode)
            }
            return data
        } catch let error as Error {
            throw error
        }catch {
            print(error.localizedDescription)
            throw .unknown
        }
    }
}

final class RecipeManagerTests: XCTestCase {
    
    func testRecipeManagerFetchRecipesError() async {
        let url =  URL(string: "https://test-url.com/recipes")!
        MockURLProtocol.mockResponses[url] = .failure(RecipeManager.Error.unknown)
        
        let sut = makeSUT()

        do {
             _ = try await sut.fetchRecipes(from: url)
            XCTFail("Expected to fail.")
        } catch {
            // Success
        }
    }
    
    func testRecipeManagerFetchRecipesReturnsInvalidURLErrorForInvalidURLResponse() async {
        let badURL = URL(string: "ftp://test.com/recipes")!
        let successfulResponse = HTTPURLResponse(url: badURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponses[badURL] = .success((successfulResponse, Data()))
        
        let sut = makeSUT()
        
        do {
            _ = try await sut.fetchRecipes(from: badURL)
            XCTFail("Expected to fail but suceeeded.")
        } catch RecipeManager.Error.invalidURL {
        } catch {
            XCTFail("Expected to fail with invalid url error but failed with \(error).")
        }
    }
    
    func testRecipeManagerFetchRecipesReturnsNetworkFailureWhenNon200HTTPURLResponse() async {
        // Given
        let testURL = URL(string: "https://test.com/recipes")!
        let non200HTTPResponse = HTTPURLResponse(url: testURL, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        MockURLProtocol.mockResponses[testURL] = .success((non200HTTPResponse, Data()))
        
        let sut = makeSUT()
        
        // when
        do {
            _ = try await sut.fetchRecipes(from: testURL)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch RecipeManager.Error.networkFailure(let actualStatusCode) {
            XCTAssertEqual(actualStatusCode, non200HTTPResponse?.statusCode, "Expected to fail with 404 status code.")
        } catch {
            XCTFail("Expected to fail with network failure but failed with \(error).")
        }
    }
    
    func testRecipeManagerFetchRecipesSucceedsReturnsData() async {
        // Given
        let url =  URL(string: "https://test-url.com/recipes")!
        let expectedData = Data("this is data".utf8)
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        MockURLProtocol.mockResponses[url] = .success((successResponse, expectedData))
        
        let sut = makeSUT()

        // When
        do {
            let actualData = try await sut.fetchRecipes(from: url)
            XCTAssertEqual(actualData, expectedData)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
}


extension RecipeManagerTests {
    func makeSUT() -> RecipeManager {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        
        return  RecipeManager(session: session)
    }
}

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
        case network(NetworkService.Error)
        case decoding(Swift.Error)
        case unknown(Swift.Error)
    }
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchRecipes(from url: URL) async throws(Error) -> [Recipe] {
        do {
            let data = try await networkService.handleRequest(for: url)
            let root = try JSONDecoder().decode(RecipeRepository.self, from: data)
            return root.recipes
        } catch let networkError as NetworkService.Error {
            throw Error.network(networkError)
        } catch {
            print(error.localizedDescription)
            throw .unknown(error)
        }
    }
}

extension RecipeManager.Error: Equatable {
    static func ==(lhs: RecipeManager.Error, rhs: RecipeManager.Error) -> Bool {
        switch (lhs, rhs) {
        case let (.network(lError), .network(rError)): return lError == rError
        case (.decoding, .decoding): return true
        case let (.unknown(lError), .unknown(rError)): return lError.localizedDescription ==  rError.localizedDescription
        default: return false
        }
    }
}

final class RecipeManagerTests: XCTestCase {
    func testRecipeManagerFetchRecipesSucceedsReturnsRecipes() async {
        // Given
        let (recipe1, recipe1JSON) = makeRecipe(id: UUID(), name: "Recipe 1", cuisine: "American")
        let (recipe2, recipe2JSON) = makeRecipe(id: UUID(), name: "Recipe 2", cuisine: "Malaysian")
        let (recipe3, recipe3JSON) = makeRecipe(id: UUID(), name: "Recipe 3", cuisine: "British")
        
        let expectedData = makeRecipesJSON([recipe1JSON, recipe2JSON, recipe3JSON])
        
        let sut = makeSUT(with: expectedData)

        // When
        do {
            let actualRecipes = try await sut.fetchRecipes(from: testURL())
            XCTAssertEqual([recipe1, recipe2, recipe3], actualRecipes)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
    
    func testRecipeManagerThrowsNetworkErrorWhenNetworkServiceFails() async {
        // Given
        let networkError = NetworkService.Error.networkFailure(statusCode: 404)
        let sut = makeSUT(andError: networkError)
        
        // When
        do {
            let _ = try await sut.fetchRecipes(from: testURL())
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch {
            switch error {
            case let .network(networkError):
                // Then
                XCTAssertEqual(networkError, .networkFailure(statusCode: 404))
            default:
                XCTFail("Expected to fail with network failure but failed with \(error)")
            }
        }
    }
}


extension RecipeManagerTests {
    func makeSUT(with data: Data? = nil, andError error: NetworkService.Error? = nil) -> RecipeManager {
        let mockNetworkService = MockNetworkService(mockData: data, mockError: error)
        
        return  RecipeManager(networkService: mockNetworkService)
    }
    
    private func makeRecipe(id: UUID, name: String, cuisine: String, imageURL: URL = testURL()) -> (Recipe, [String : Any]) {
        (
            Recipe(id: id.uuidString,
                   name: name,
                   cuisine: cuisine,
                   smallPhotoURL: imageURL.absoluteString),
            [
                "uuid": id.uuidString,
                "name":  name,
                "cuisine": cuisine,
                "photo_url_small": imageURL.absoluteString
            ].compactMapValues { $0 }
        )
    }
    
    private func makeRecipesJSON(_ items: [[String: Any]]) -> Data {
        let json = ["recipes" : items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

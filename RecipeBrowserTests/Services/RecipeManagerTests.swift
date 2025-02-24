//
//  RecipeManagerTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/19/25.
//

import XCTest
@testable import RecipeBrowser

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
            let actualRecipes = try await sut.fetchRecipes(from: .mock)
            XCTAssertEqual([recipe1, recipe2, recipe3], actualRecipes)
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
    }
    
    func testRecipeManagerThrowsNetworkErrorWhenNetworkServiceFails() async {
        // Given
        let expectedNetworkError = NetworkService.Error.networkFailure(statusCode: 404)
        let sut = makeSUT(andError: expectedNetworkError)
        
        // When
        do {
            let _ = try await sut.fetchRecipes(from: .mock)
            XCTFail("Expected to fail with network failure but succeeded.")
        } catch {
            switch error {
            case let .network(actualNetworkError):
                // Then
                XCTAssertEqual(actualNetworkError, expectedNetworkError)
            default:
                XCTFail("Expected to fail with network failure but failed with \(error)")
            }
        }
    }
    
    func testRecipeManagerThrowsDecodingErrorWhenJSONFailsToDecodeCorrectly() async {
        // Given
        let invalidJSONString = "{ recipes : \"invalid\" }"
        let invalidData = Data(invalidJSONString.utf8)
        let sut = makeSUT(with: invalidData)
        
        // When
        do {
            let _ = try await sut.fetchRecipes(from: .mock)
            XCTFail("Expected to fail with decoding error but succeeded.")
        } catch {
            // Then
            switch error {
            case .decoding: return
            default:
                XCTFail("Expected to fail with decoding error but failed with \(error).")
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

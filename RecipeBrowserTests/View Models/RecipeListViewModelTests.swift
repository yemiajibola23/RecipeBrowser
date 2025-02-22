//
//  RecipeListViewModelTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/20/25.
//

import XCTest
@testable import RecipeBrowser

final class RecipeListViewModelTests: XCTestCase {
    func testLoadRecipesSuccess() async {
        // Given
        let expectedRecipes = Recipe.mock
        let (sut, _) = makeSUT(recipes: expectedRecipes)
        
        // When
        await sut.loadRecipes(from: .mock)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage, "Should not have error message")
        XCTAssertEqual(sut.recipes, expectedRecipes)
        XCTAssertFalse(sut.showAlert)
    }
    
    func testLoadRecipeFailure() async {
        // Given
        let expectedError = RecipeManager.Error.network(.networkFailure(statusCode: 404))
        let (sut, _) = makeSUT(error: expectedError)
        
        // When
        await sut.loadRecipes(from: .mock)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage, "Should have error message")
        XCTAssertEqual(sut.recipes, [])
        XCTAssertTrue(sut.showAlert)
    }
    
    func testRecipeListViewModelClearsErrorIfRefreshed() async {
        
        // Given
        let decodingError = DecodingError.keyNotFound(Recipe.CodingKeys.cuisine, .init(codingPath: [], debugDescription: "Could not find cuisine"))
        let expectedError = RecipeManager.Error.decoding(decodingError)
        let (sut, recipeManager) = makeSUT(error: expectedError)
        
        // When
        await sut.loadRecipes(from: .mock)
        XCTAssertNotNil(sut.errorMessage, "Should have error message")
        XCTAssertEqual(sut.recipes, [])
        XCTAssertTrue(sut.showAlert)
        
        let expectedRecipes = Recipe.mock
        recipeManager.mockRecipes = expectedRecipes
        recipeManager.mockError = nil
        
        await sut.loadRecipes(from: .mock)
        
        // Then
        XCTAssertNil(sut.errorMessage, "Should not have error message")
        XCTAssertEqual(sut.recipes, expectedRecipes)
        
    }
}

private extension RecipeListViewModelTests {
    func makeSUT(recipes: [Recipe] = [], error: RecipeManager.Error? = nil) -> (RecipeListViewModel, MockRecipeManager) {
        let mockRecipeManager = MockRecipeManager(mockRecipes: recipes, mockError: error)
        
        return (RecipeListViewModel(recipeManager: mockRecipeManager), mockRecipeManager)
    }
    
    class MockRecipeManager: RecipeManagerProtocol {
        var mockRecipes: [Recipe]
        var mockError: RecipeManager.Error?
        
        init(mockRecipes: [Recipe] = [], mockError: RecipeManager.Error? = nil) {
            self.mockRecipes = mockRecipes
            self.mockError = mockError
        }
        
        func fetchRecipes(from url: URL) async throws -> [Recipe] {
            if let error = mockError { throw error }
            
            return mockRecipes
        }
    }
}

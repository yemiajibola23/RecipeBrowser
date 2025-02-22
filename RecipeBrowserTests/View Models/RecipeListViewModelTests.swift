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
        let sut = makeSUT(recipes: expectedRecipes)
        
        // When
        await sut.loadRecipes(from: testURL())
        
        // Then
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.recipes, expectedRecipes)
        
    }
    
    func testLoadRecipeFailure() async {
        // Given
        let expectedError = RecipeManager.Error.network(.networkFailure(statusCode: 404))
        let sut = makeSUT(error: expectedError)
        
        // When
        await sut.loadRecipes(from: testURL())
        
        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.recipes, [])
    }
    
    func testRecipeListViewModelLoadRecipesShowsErrorMessageWhenNoRecipesAvailable() async {
        // Given
        let sut = makeSUT()
        
        // When
        await sut.loadRecipes(from: testURL())
        
        // Then
        XCTAssertEqual(sut.errorMessage, RecipeListViewModel.ErrorMessages.empty.rawValue)
        XCTAssertEqual(sut.recipes, [])
    }
}

private extension RecipeListViewModelTests {
    func makeSUT(recipes: [Recipe] = [], error: RecipeManager.Error? = nil) -> RecipeListViewModel {
        let mockRecipeManager = MockRecipeManager(mockRecipes: recipes, mockError: error)
        
        return RecipeListViewModel(recipeManager: mockRecipeManager)
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

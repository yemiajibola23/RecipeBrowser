//
//  RecipeListViewModelTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/20/25.
//

import XCTest
@testable import RecipeBrowser

class RecipeListViewModel {
    let recipeManager: RecipeManagerProtocol
    
    var recipes: [Recipe] = []
    var errorMessage: String?
    
    init(recipeManager: RecipeManagerProtocol) {
        self.recipeManager = recipeManager
    }
    
    func loadRecipes(from url: URL) async {
        do {
            recipes = try await recipeManager.fetchRecipes(from: url)
            errorMessage = nil
        } catch {
            recipes = []
            errorMessage = error.localizedDescription
        }
    }
}

final class RecipeListViewModelTests: XCTestCase {
    func testLoadRecipesSuccess() async {
        // Given
        let expectedRecipes = Recipe.mock
        let mockRecipeManager = MockRecipeManager(mockRecipes: expectedRecipes)
        let sut = RecipeListViewModel(recipeManager: mockRecipeManager)
        
        // When
        await sut.loadRecipes(from: testURL())
        
        // Then
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.recipes, expectedRecipes)
        
    }
    
    func testLoadRecipeFailure() async {
        // Given
        let expectedError = RecipeManager.Error.network(.networkFailure(statusCode: 404))
        let mockRecipeManager = MockRecipeManager(mockError: expectedError)
        let sut = RecipeListViewModel(recipeManager: mockRecipeManager)
        
        // When
        await sut.loadRecipes(from: testURL())
        
        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.recipes, [])
    }
}

private extension RecipeListViewModelTests {
    class MockRecipeManager: RecipeManagerProtocol {
        var mockRecipes: [Recipe]?
        var mockError: RecipeManager.Error?
        
        init(mockRecipes: [Recipe]? = nil, mockError: RecipeManager.Error? = nil) {
            self.mockRecipes = mockRecipes
            self.mockError = mockError
        }
        
        func fetchRecipes(from url: URL) async throws -> [Recipe] {
            if let error = mockError { throw error }
            
            guard let recipes = mockRecipes else { throw NSError(domain: "MockRecipeManager", code: 0) }
            
            return recipes
        }
    }
}

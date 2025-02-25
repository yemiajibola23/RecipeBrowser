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
    
    func testRecipeListViewModelFetchRecipesUsesCacheWhenLessThan1MinuteOld() async {
        // Given
        let (sut, _) = makeSUT(recipes: Recipe.mock)
        
        await sut.loadRecipes(from: .mock)
        let firstFetchTime = sut.lastFetchTime
        
        // When
        try? await Task.sleep(nanoseconds: 3_000_000)
        await sut.loadRecipes(from: .mock)
        
        // Then
        XCTAssertEqual(sut.recipes.count, 3)
        XCTAssertEqual(sut.lastFetchTime, firstFetchTime, "Last fetch time should not change when using cache.")
    }
    
    func testRecipeListViewModelFetchRecipesCallsNetworkWhenCacheIsMoreThan1MinuteOld() async {
        // Given
        let (sut, _) = makeSUT(recipes: Recipe.mock)
        
        await sut.loadRecipes(from: .mock)
        let firstFetchTime = sut.lastFetchTime
        
        // When
        sut.lastFetchTime = Date().addingTimeInterval(-90)
        await sut.loadRecipes(from: .mock)
        
        // Then
        XCTAssertEqual(sut.recipes.count, 3)
        XCTAssertNotEqual(sut.lastFetchTime, firstFetchTime, "Last fetch time should change because of update.")
    }
    
    func testRecipeListViewModelFetchRecipesCallsNetworkWhenForcedToRefresh() async {
        // Given
        let (sut, manager) = makeSUT(recipes: Recipe.mock)
        
        // When
        await sut.loadRecipes(from: .mock)
        let firstFetchTime = sut.lastFetchTime
        
        manager.mockRecipes = [Recipe(id: "2", name: "Cool Recipe", cuisine: "Mandarin")]
        try? await Task.sleep(nanoseconds: 3_000_000)
        await sut.loadRecipes(from: .mock, forceRefresh: true)
        
        // Then
        XCTAssertEqual(sut.recipes.count, 1)
        XCTAssertNotEqual(firstFetchTime, sut.lastFetchTime, "Last fetch time should change because of update.")
    }
    
    func testRecipeListViewModelApplyFilterReturnsFilteredRecipes() async {
        let mockRecipes = [
            Recipe(id: "1", name: "Spaghetti", cuisine: "Italian", smallPhotoURL: "https://example.com/image1.jpg"),
                   Recipe(id: "2", name: "Pizza", cuisine: "Italian", smallPhotoURL: "https://example.com/image2.jpg"),
                   Recipe(id: "3", name: "Sushi", cuisine: "Japanese", smallPhotoURL: "https://example.com/image3.jpg"),
                   Recipe(id: "4", name: "Tacos", cuisine: "Mexican", smallPhotoURL: "https://example.com/image4.jpg"),
                   Recipe(id: "5", name: "Burger", cuisine: "American", smallPhotoURL: "https://example.com/image5.jpg")
               ]
        
        let (sut, _) = makeSUT(recipes: mockRecipes)
        
        await sut.loadRecipes(from: .mock)
        
        sut.searchQuery = "su"
        
        let filteredRecipes = sut.filteredRecipes
        XCTAssertEqual(filteredRecipes.count, 1, "Should only return 1 recipe.")
        XCTAssertEqual(filteredRecipes.first?.name, "Sushi", "Search should return Sushi.")
    }
    
    func testRecipeListViewModelApplyFilterToCuisineReturnsFilteredRecipes() async {
        let mockRecipes = [
            Recipe(id: "1", name: "Spaghetti", cuisine: "Italian", smallPhotoURL: "https://example.com/image1.jpg"),
                   Recipe(id: "2", name: "Pizza", cuisine: "Italian", smallPhotoURL: "https://example.com/image2.jpg"),
                   Recipe(id: "3", name: "Sushi", cuisine: "Japanese", smallPhotoURL: "https://example.com/image3.jpg"),
                   Recipe(id: "4", name: "Tacos", cuisine: "Mexican", smallPhotoURL: "https://example.com/image4.jpg"),
                   Recipe(id: "5", name: "Burger", cuisine: "American", smallPhotoURL: "https://example.com/image5.jpg")
               ]
        
        let (sut, _) = makeSUT(recipes: mockRecipes)
        
        await sut.loadRecipes(from: .mock)
        
        sut.selectedCuisine = "Italian"
        
        let filteredRecipes = sut.filteredRecipes
        XCTAssertEqual(filteredRecipes.count, 2, "Should only return 2 recipe.")
        XCTAssertTrue(filteredRecipes.allSatisfy {$0.cuisine == "Italian"},  "All results should have italian cuisine.")
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
        
        func fetchRecipes(from endpoint: API.Endpoint) async throws -> [Recipe] {
            if let error = mockError { throw error }
            
            return mockRecipes
        }
    }
}

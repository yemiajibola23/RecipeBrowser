//
//  RecipeBrowserPerformanceTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/23/25.
//

import XCTest
@testable import RecipeBrowser

final class RecipeBrowserPerformanceTests: XCTestCase {
    func testAPIResponseTime() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let (_, recipeJSON) = makeRecipe(name: "Test Recipe", cuisine: "Test Cuisine")
        mockNetworkService.mockData = makeRecipesJSON([recipeJSON])
        let recipeManager = RecipeManager(networkService: mockNetworkService)
        
        let expectation = expectation(description: "API response time test.")
        let startTime = Date()
        
        do {
            // When
            _ = try await recipeManager.fetchRecipes(from: .mock)
            let elapsedTime = Date().timeIntervalSince(startTime)
            
            // Then
            XCTAssertTrue(elapsedTime < 2.0, "API response time took too long: \(elapsedTime) seconds.")
        } catch {
            XCTFail("Expected to succeed but failed with \(error)")
        }
        
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}

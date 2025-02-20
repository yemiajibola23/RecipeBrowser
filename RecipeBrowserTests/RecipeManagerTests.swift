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
    
    func fetchRecipes(from url: URL) async throws -> [Recipe] {
        throw Error.unknown
    }
}

final class RecipeManagerTests: XCTestCase {
    
    func testRecipeManagerFetchRecipesError() async {
        let sut = RecipeManager()
        let url =  URL(string: "https://test-url.com/recipes")!
        do {
            try _ = await sut.fetchRecipes(from: url)
            XCTFail("Expected to fail.")
        } catch {
            
            // Success
        }
        
    }

}

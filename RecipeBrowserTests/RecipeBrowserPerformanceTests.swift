//
//  RecipeBrowserPerformanceTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/23/25.
//

import XCTest
import Darwin
@testable import RecipeBrowser

final class RecipeBrowserPerformanceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var recipeManager: RecipeManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        recipeManager = RecipeManager(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        recipeManager = nil
    }
    
    func testAPIResponseTime() async {
        // Given
        let (_, recipeJSON) = makeRecipe(name: "Test Recipe", cuisine: "Test Cuisine")
        mockNetworkService.mockData = makeRecipesJSON([recipeJSON])
        
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
    
    func testImageLoadingMemoryUsage() async {
        let initialMemoryUsage = getMemoryUsage()
        
        Task {
            _ = try await recipeManager.fetchRecipes()
        }
        
        let finalMemoryUsage = getMemoryUsage()
        XCTAssertTrue(finalMemoryUsage - initialMemoryUsage < 50, "Excessive memory usage detected.")
    }
}

private extension RecipeBrowserPerformanceTests {
    func getMemoryUsage() -> Int {
        var info = task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<Int32>.size) // ✅ Corrected count calculation
        
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) { ptr in
                task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), ptr, &count) // ✅ Corrected type conversion
            }
        }
        
        return result == KERN_SUCCESS ? Int(info.resident_size / 1024 / 1024) : -1 // ✅ Con
    }
}

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
        super.tearDown()
    }
    
    func testAPIResponseTime() async {
        // Given
        mockNetworkService.mockData = generateMockRecipeData(count: 2)
        
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
    
    func testRecipeFetchingPerformance() async {
        print("Debug: recipeManager is \(recipeManager == nil ? "nil" : "initialized")")
        print("Debug: mockNetworkService is \(mockNetworkService == nil ? "nil" : "initialized")")
        
        mockNetworkService.mockData = generateMockRecipeData(count: 1000)
        
        await measureAsync {
            do {
                _ = try await self.recipeManager.fetchRecipes()
            } catch {
                XCTFail("Fetching large dataset failed: \(error)")
            }
        }
    }
    
    func testDiskCacheWriteSpeeds() {
        let diskCache = DiskCache()
        let testImage = UIImage(systemName: "star")!
        
        measure {
            diskCache.saveImage(testImage, for: testURL())
        }
        
        diskCache.clearCache()
    }
    
    func testDiskCacheReadSpeeds() {
        let diskCache = DiskCache()
        let testImage = UIImage(systemName: "star")!
        
        diskCache.saveImage(testImage, for: testURL())
        
        measure {
            _ = diskCache.loadImage(for: testURL())
        }
        
        diskCache.clearCache()
    }
    
    func testPullToRefreshSpeed() async {
        mockNetworkService.mockData = generateMockRecipeData(count: 10)
        let viewModel = RecipeListViewModel(recipeManager: recipeManager)
        
        await measureAsync {
            _ = await viewModel.loadRecipes(forceRefresh: true)
        }
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
    func measureAsync(block: @escaping () async -> Void) async {
        let start = Date()
        await block()
        let end = Date()
        print("⏱ Execution time: \(end.timeIntervalSince(start)) seconds")
    }
    
    func getMemoryUsage() -> Int {
        var info = task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<Int32>.size)
        
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) { ptr in
                task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), ptr, &count)
            }
        }
        
        return result == KERN_SUCCESS ? Int(info.resident_size / 1024 / 1024) : -1
    }
    
    func generateMockRecipeData(count: Int) -> Data {
        let recipes = (1...count).map { i in
            Recipe(id: "\(i)", name: "Recipe \(i)", cuisine: "Test cuisine", smallPhotoURL: "https://example.com/image\(i).jpg")
        }
        
        return try! JSONEncoder().encode(RecipeRepository(recipes: recipes))
    }
}

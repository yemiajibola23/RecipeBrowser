//
//  DependencyContainerTests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/21/25.
//

import XCTest
@testable import RecipeBrowser

class DependencyContainer {
    static let shared = DependencyContainer()
    
    let networkService: NetworkServiceProtocol
    let imageManager: ImageManagerProtocol
    
    private init() {
        networkService = NetworkService(session: .shared)
        imageManager = ImageManager(
            diskCache: DiskCache(),
            memoryCache: InMemoryCache(),
            downloader: ImageDownloader(networkService: networkService))
    }
    
    func makeRecipeManager() -> RecipeManager { RecipeManager(networkService: networkService) }
}

final class DependencyContainerTests: XCTestCase {
    func testDependencyContainerNetworkServiceIsOnlyOneInstance() {
        let container = DependencyContainer.shared
        
        let instance1 = container.networkService
        let instance2 = container.networkService
        
        XCTAssertTrue(instance1 === instance2, "Network service should be a singleton instance.")
    }
    
    func testDependencyContainerImageManagerIsOnlyOneInstance() {
        let container = DependencyContainer.shared
        
        let instance1 = container.imageManager
        let instance2 = container.imageManager
        
        XCTAssertTrue(instance1 === instance2, "Image manager should be a singleton instance.")
    }
    
    func testDependencyContainerMakeRecipeManagerMakesSeparateInstances() {
        let container = DependencyContainer.shared
        
        let instance1 = container.makeRecipeManager()
        let instance2 = container.makeRecipeManager()
        
        XCTAssertFalse(instance1 === instance2, "Recipe manager should have separate instance.")
    }
}

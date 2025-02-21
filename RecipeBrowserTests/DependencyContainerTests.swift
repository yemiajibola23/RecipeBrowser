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
    
    func makeRecipeItemViewModel(recipe: Recipe) -> RecipeItemViewModel { RecipeItemViewModel(recipe: recipe, imageManager: imageManager) }
}

final class DependencyContainerTests: XCTestCase {
    let sut = DependencyContainer.shared

    
    func testDependencyContainerNetworkServiceIsOnlyOneInstance() {
        assertSingletonInstance(instanceProvider: { sut.networkService as AnyObject }, message: "Network service should be a singleton instance.")
    }
    
    func testDependencyContainerImageManagerIsOnlyOneInstance() {
        assertSingletonInstance(instanceProvider: {sut.imageManager as AnyObject }, message: "Image manager should be a singleton instance.")
    }
    
    func testDependencyContainerMakeRecipeManagerMakesSeparateInstances() {
        assertSeparateInstances(instanceProvider: { sut.makeRecipeManager() }, message: "Recipe manager should have separate instances.")
    }
    
    func testDependencyContainerMakeRecrpeItemViewModelMakesSeparateInstances() {
        let recipe = Recipe(id: "1", name: "Test", cuisine: "American")
        assertSeparateInstances(instanceProvider: { sut.makeRecipeItemViewModel(recipe: recipe) }, message: "Recipe item view model should have separate instances.")
    }
}


private extension DependencyContainerTests {
    func assertSingletonInstance<T: AnyObject>(instanceProvider: () -> T,
                                               message: String,
                                               file: StaticString = #file,
                                               line: UInt = #line) {
        let instance1 = instanceProvider()
        let instance2 = instanceProvider()
        
        XCTAssertTrue(instance1 === instance2, message, file: file, line: line)

    }
    
    func assertSeparateInstances<T: AnyObject>(instanceProvider: () -> T,
                                    message: String,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
        let instance1 = instanceProvider()
        let instance2 = instanceProvider()
        
        XCTAssertFalse(instance1 === instance2, message, file: file, line: line)
    }
}

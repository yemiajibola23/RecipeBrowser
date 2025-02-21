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
    
    var networkService: NetworkServiceProtocol
    
    private init() {
        networkService = NetworkService(session: .shared)
    }
    
}

final class DependencyContainerTests: XCTestCase {
    
    func testNetworkServiceIsOnlyOneInstance() {
        let container = DependencyContainer.shared
        
        let instance1 = container.networkService
        let instance2 = container.networkService
        
        XCTAssertTrue(instance1 === instance2, "Network container should be a singleton instance.")
    }
}

//
//  APITests.swift
//  RecipeBrowserTests
//
//  Created by Amira Ajibola  on 2/21/25.
//

import XCTest
@testable import RecipeBrowser

final class APITests: XCTestCase {
    func testAPIAllEndpointReturnsCorrectURL() {
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let generatedURL = API.url(for: .all)
        
        XCTAssertEqual(expectedURL, generatedURL)
    }
    
    func testAPMalformedEndpointReturnsCorrectURL() {
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        let generatedURL = API.url(for: .malformed)
        
        XCTAssertEqual(expectedURL, generatedURL)
    }
    
    func testAPIEmptyEndpointReturnsCorrectURL() {
        let expectedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        let generatedURL = API.url(for: .empty)
        
        XCTAssertEqual(expectedURL, generatedURL)
    }
}

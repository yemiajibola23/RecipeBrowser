//
//  RecipeBrowserUITestsLaunchTests.swift
//  RecipeBrowserUITests
//
//  Created by Amira Ajibola  on 2/23/25.
//

import XCTest

final class RecipeBrowserUITestsLaunchTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testFetchRecipesUpdatesUI() {
        let recipes = app.table
    }
  
}

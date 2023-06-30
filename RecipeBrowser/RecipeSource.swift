//
//  RecipeSource.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/30/23.
//

import UIKit


protocol MealRepository {
    func getMealsForCategory(category: String) async throws -> MealResponse
    func getMealDetails(mealID: String) async throws -> MealResponse
    func getImage(url: String) async throws -> UIImage?
}

final class RecipeSource: MealRepository {
    let networkHandler = NetworkHandler()
    
    func getMealsForCategory(category: String) async throws -> MealResponse {
        let request = MealRequest.filterByCategory(category)
        return try await networkHandler.handle(request: request)
    }
    
    func getMealDetails(mealID: String) async throws -> MealResponse {
        let request = MealRequest.lookupMealDetailsById(mealID)
        return try await networkHandler.handle(request: request)
    }
    
    func getImage(url: String) async throws -> UIImage? {
        let request = ImageRequest.getImage(url)
        return try await networkHandler.handleImage(request: request)
    }
}

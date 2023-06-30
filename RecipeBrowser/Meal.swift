//
//  Meal.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/23/23.
//

import Foundation

struct MealResponse: Decodable {
    var meals: [Meal]
}


struct MealDetailResponse: Decodable {
    var mealDetails: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case mealDetails = "meals"
    }
}

struct Meal: Decodable {
    var id: String
    var name: String
    var thumbnail: String
    var category: String
    var origin: String
    var instructions: String
    var ingredients: [Ingredient]?
}


extension Meal {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: String?].self)
        
        var i = 1
        var ingredients: [Ingredient] = []
        
        while let ingredient = dict["strIngredient\(i)"] as? String,
              let measurement = dict["strMeasure\(i)"] as? String,
              !ingredient.isEmpty,
              !measurement.isEmpty {
            ingredients.append(Ingredient(name: ingredient, measurement: measurement))
            i += 1
        }
        self.ingredients = ingredients
        self.id = dict["idMeal"] as? String ?? ""
        self.name = dict["strMeal"] as? String ?? ""
        self.thumbnail = dict["strMealThumb"] as? String ?? ""
        self.origin = dict["strArea"] as? String ?? ""
        self.instructions = dict["strInstructions"] as? String ?? ""
        self.category = dict["strCategory"] as? String ?? ""
        
    }
    
    static let test = Meal(id: "53049", name: "Apam balik", thumbnail:  "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", category: "Dessert", origin: "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.", instructions: "https://www.youtube.com/watch?v=6R8ffRRJcrg", ingredients: Meal.ingredientTest )
    
    static let ingredientTest: [Ingredient]?  = [
        Ingredient(name: "Milk", measurement: "200ml"),
        Ingredient(name: "Oil", measurement: "60ml"),
        Ingredient(name: "Eggs", measurement: "2"),
        Ingredient(name: "Flour", measurement: "1600g"),
        Ingredient(name: "Baking Powder", measurement: "3 tsp"),
        Ingredient(name: "Salt", measurement: "1/2 tsp"),
        Ingredient(name: "Unsalted Butter", measurement: "25g"),
        Ingredient(name: "Sugar", measurement: "45g"),
        Ingredient(name: "Peanut Butter", measurement: "3 tbs")
    ]
}


struct Ingredient: Decodable {
    var name: String
    var measurement: String
}

//enum Category: String, Codable {
//    case dessert
//    case beef
//    case breakfast
//    case chicken
//    case goat
//    case lamb
//    case misc
//    case pasta
//    case pork
//    case seafood
//    case side
//    case starter
//    case vegan
//    case vegetarian
//}

//enum Origin: String, Codable {
//    case american
//    case british
//    case chinese
//    case croatian
//    case dutch
//    case egyptian
//    case filipino
//    case french
//    case greek
//    case indian
//    case irish
//    case italian
//    case jamaican
//    case japanese
//    case kenyan
//    case malaysian
//    case mexican
//    case moroccan
//    case polish
//    case portuguese
//    case russian
//    case spanish
//    case thai
//    case tunisian
//    case turkish
//    case unknown
//    case vietnamese
//}

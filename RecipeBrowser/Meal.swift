//
//  Meal.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/23/23.
//

import Foundation

struct MealDirectory: Codable {
    var meals: [Meal]
}

struct Meal: Codable {
    var id: String
    var name: String
    var thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
    }
}

struct MealDetail: Codable {
    var id: String
    var name: String
    var thumbnail: String
    var origin: Origin
    var instructions: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case origin = "strArea"
        case instructions = "strInstructions"
    }
}


enum Category: String, Codable {
    case dessert
    case beef
    case breakfast
    case chicken
    case goat
    case lamb
    case misc
    case pasta
    case pork
    case seafood
    case side
    case starter
    case vegan
    case vegetarian
}

enum Origin: String, Codable {
    case american
    case british
    case chinese
    case croatian
    case dutch
    case egyptian
    case filipino
    case french
    case greek
    case indian
    case irish
    case italian
    case jamaican
    case japanese
    case kenyan
    case malaysian
    case mexican
    case moroccan
    case polish
    case portuguese
    case russian
    case spanish
    case thai
    case tunisian
    case turkish
    case unknown
    case vietnamese
}

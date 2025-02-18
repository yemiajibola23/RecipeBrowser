//
//  Recipe.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import Foundation

struct RecipeRepositiory: Decodable {
    var recipes: [Recipe]
}

struct Recipe {
    var id: String
    var name: String
    var cuisine: String
    var smallPhotoURL: String?
    var largePhotoURL: String?
    var sourceURL: String?
    var youtubeURL: String?
}


extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name = "name"
        case cuisine = "cuisine"
        case smallPhotoURL = "photo_url_small"
        case largePhotoURL = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

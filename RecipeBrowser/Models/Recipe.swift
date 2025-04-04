//
//  Recipe.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import Foundation

struct RecipeRepository: Codable {
    var recipes: [Recipe]
}

struct Recipe: Identifiable {
    var id: String
    var name: String
    var cuisine: Cuisine
    var smallPhotoURL: String?
    var largePhotoURL: String?
    var sourceURL: String?
    var youtubeURL: String?
    
    static let mock: [Recipe] = [
        Recipe(id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", name: "Apam Balik", cuisine: .malaysian, smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
        Recipe(id: "891a474e-91cd-4996-865e-02ac5facafe3", name: "Battenberg Cake", cuisine: .british, smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg", largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg"),
        Recipe(id: "6377de22-4ec2-44c4-9e76-260be2e4fd90", name: "Chinon Apple Tarts", cuisine: .french,
               smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/small.jpg",
               largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/large.jpg")
        
    ]
}


extension Recipe: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name = "name"
        case cuisine = "cuisine"
        case smallPhotoURL = "photo_url_small"
        case largePhotoURL = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let cuisineString = try container.decode(String.self, forKey: .cuisine).lowercased()
        cuisine = Cuisine(rawValue: cuisineString) ?? .unknown
        smallPhotoURL = try container.decodeIfPresent(String.self, forKey: .smallPhotoURL)
        largePhotoURL = try container.decodeIfPresent(String.self, forKey: .largePhotoURL)
        sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
    }
}

extension Recipe: Equatable {}

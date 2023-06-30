//
//  RecipeRequest.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/30/23.
//

import Foundation

struct Constants {
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol APIRequest {
    var url: String? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var params: Any? { get }
    var timeoutInterval: TimeInterval { get }
}
extension APIRequest {
    var url: String? { nil }
    var queryItems: [URLQueryItem]? { [] }
    var params: Any? { nil }
    var timeoutInterval: TimeInterval { 10.0 }
}

enum MealRequest {
    case lookupMealDetailsById(String)
    case filterByCategory(String)
}

extension MealRequest: APIRequest {
    var path: String {
        switch self {
        case .lookupMealDetailsById:
            return "lookup.php"
        case .filterByCategory:
            return "filter.php"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .lookupMealDetailsById:
            return .get
        case .filterByCategory:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .lookupMealDetailsById(let id):
            return [URLQueryItem(name: "i", value: id)]
        case .filterByCategory(let category):
            return [URLQueryItem(name: "c", value: category)]
        }
    }
    
}



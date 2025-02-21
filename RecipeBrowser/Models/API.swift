//
//  APIEndpoint.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/21/25.
//

import Foundation

struct API {
    static let baseURL =  URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes")!
    
    enum Endpoint: String {
        case all = ".json"
        case malformed = "-malformed.json"
        case empty = "-empty.json"
    }
    
    static func url(for endpoint: Endpoint = .all) -> URL {
        return baseURL.appending(path: endpoint.rawValue)
    }
}

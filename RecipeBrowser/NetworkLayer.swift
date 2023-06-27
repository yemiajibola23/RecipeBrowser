//
//  NetworkLayer.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/26/23.
//

import Foundation

enum NetworkLayerError: Error {
    case urlFailure
    case unknown
    case malformedJson
    case dataError
}

typealias MealResult = (Result<MealDirectory, NetworkLayerError>) -> Void

//enum APIEndpoints {
//    case search = "search.php?s="
//    case ingredient = ""
//}

class NetworkHandler {
    static let dessertEndpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    static let detailsEndpoint = "www.themealdb.com/api/json/v1/1/lookup.php?i="
    
    static func fetchMeals(completion: @escaping MealResult) {
        guard let url = URL(string: dessertEndpoint) else { completion(.failure(.urlFailure)); return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let directory = try JSONDecoder().decode(MealDirectory.self, from: data)
                completion(.success(directory))
                
            } catch {
                print(error)
                completion(.failure(.malformedJson))
            }
            
            
        }
        
        task.resume()
        
    }
    
    static func fetchMealDetails(with id: String, completion: MealResult) {
        
    }
}

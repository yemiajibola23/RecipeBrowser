//
//  NetworkLayer.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/26/23.
//

import UIKit

enum NetworkLayerError: Error {
    case urlFailure
    case unknown
    case malformedJson
    case dataError
}

typealias MealResult = (Result<[Meal], NetworkLayerError>) -> Void
typealias MealDetailResult = (Result<[MealDetail], NetworkLayerError>) -> Void
typealias ImageResult = (Result<UIImage, NetworkLayerError>) -> Void

//enum APIEndpoints {
//    case search = "search.php?s="
//    case ingredient = ""
//}

class NetworkHandler {
    static let dessertEndpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    static let detailsEndpoint = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    
    static func fetchMeals(completion: @escaping MealResult) {
        guard let url = URL(string: dessertEndpoint) else { completion(.failure(.urlFailure)); return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataError))
                }
                return
            }
            
            do {
                let directory = try JSONDecoder().decode(MealDirectory.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(directory.meals))
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.malformedJson))
                }
            }
            
            
        }
        
        task.resume()
        
    }
    
    // TODO: - Put task on background trhead
    
    static func fetchMealDetails(with id: String, completion: @escaping MealDetailResult) {
        let details = detailsEndpoint + id
        print(details)
        
        guard let detailsUrl = URL(string: details) else { completion(.failure(.urlFailure)); return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: detailsUrl)) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataError))                    
                }
                return
            }
            
            do {
                let mealDetail = try JSONDecoder().decode(MealDetailContainer.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(mealDetail.mealDetails))
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.malformedJson))
                }
            }
            
            
        }
        
        task.resume()
    }
    
    
    static func fetchImage(urlString: String, completion: @escaping ImageResult) {
        // Check user default for image
        if let imageData = UserDefaults.standard.data(forKey: urlString), let image = UIImage(data: imageData) {
            completion(.success(image))
            return
        }
        
        guard let url = URL(string: urlString) else { completion(.failure(.urlFailure)); return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let imageData = data, let image = UIImage(data: imageData) {
                UserDefaults.standard.set(imageData, forKey: urlString)
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
                return
            }
            
            if let _ = error {
                completion(.failure(.unknown))
            }
        }
        
        task.resume()
    }
}

//
//  NetworkLayer.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/26/23.
//

import UIKit

enum NetworkLayerError: Error {
    case urlFailure
    case unknown(_ message: String)
    case malformedJson(_ key: String)
    case dataError
    case networkError
    case httpError
    case statusError(_ code: Int)
    
    var description: String {
        switch self {
            
        case .urlFailure:
            return "There was an issue with the url."
        case .unknown(let error):
            return "An unknown issue occurred.\n \(error)"
        case .malformedJson(_):
            return ""
        case .dataError:
            return ""
        case .networkError:
            return ""
        case .httpError:
            return "There was an issue with the http."
        case .statusError(let code):
            return "HTTP status code error: \(code)."
        }
    }
}


struct NetworkRequest {
    var request: URLRequest
    
    init(apiRequest: APIRequest) {
        var urlcomponents = URLComponents(string: apiRequest.url?.description ?? Constants.baseURL) // if there is nothing inside api.url than send me the base url
        
        let path = urlcomponents?.path.appending(apiRequest.path) ?? ""
        
        urlcomponents?.path = path
        
        if let queryItem = apiRequest.queryItems {
            urlcomponents?.queryItems =  queryItem
        }
        guard let fullUrl = urlcomponents?.url else {
            assertionFailure("Did not load the url")
            request = URLRequest(url: URL(string: "")!)
            return
        }
        request = URLRequest(url: fullUrl)
        request.httpMethod = apiRequest.method.rawValue
        request.timeoutInterval = apiRequest.timeoutInterval
    }
}




final class NetworkHandler {
    
    func handleImage(request: APIRequest) async throws -> UIImage? {
        if let urlString = request.url, let imageData =  UserDefaults.standard.data(forKey: urlString) {
            return UIImage(data: imageData)
        }
        
        
        do {
            let networkRequest = NetworkRequest(apiRequest: request)
            let (data, response) = try await URLSession.shared.data(for: networkRequest.request)
            
            guard let response = response as? HTTPURLResponse else { throw NetworkLayerError.httpError }
            
            if response.statusCode == 200 {
                do {
                    UserDefaults.standard.setValue(data, forKey: request.url ?? UUID().uuidString)
                    return UIImage(data: data)
                }
                
            } else {
                throw NetworkLayerError.statusError(response.statusCode)
            }
        }
            
    }
    
    func handle<T: Decodable>(request: APIRequest) async throws -> T {
        do {
            let networkRequest = NetworkRequest(apiRequest: request)
            let (data, response) = try await URLSession.shared.data(for: networkRequest.request)
            
            guard let response = response as? HTTPURLResponse else { throw NetworkLayerError.httpError }
            
            if response.statusCode == 200 {
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                }
                
            } else {
                throw NetworkLayerError.statusError(response.statusCode)
            }
        }
    }
}

//
//  RecipeManager.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/20/25.
//

import Foundation

protocol RecipeManagerProtocol {
    func fetchRecipes(from endpoint: API.Endpoint) async throws -> [Recipe]
}

final class RecipeManager: RecipeManagerProtocol {
    enum Error: Swift.Error {
        case network(NetworkService.Error)
        case decoding(Swift.Error)
        case unknown
    }
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchRecipes(from endpoint: API.Endpoint = .all) async throws(Error) -> [Recipe] {
        let url = API.url(for: endpoint)
        
        do {
            let data = try await networkService.handleRequest(for: url)
            let root = try JSONDecoder().decode(RecipeRepository.self, from: data)
            return root.recipes
        } catch let networkError as NetworkService.Error {
            throw .network(networkError)
        } catch let decodingError as DecodingError {
            throw .decoding(decodingError)
        } catch {
            print(error.localizedDescription)
            throw .unknown
        }
    }
}

extension RecipeManager.Error: Equatable {
    static func ==(lhs: RecipeManager.Error, rhs: RecipeManager.Error) -> Bool {
        switch (lhs, rhs) {
        case let (.network(lError), .network(rError)): return lError == rError
        case (.decoding, .decoding),
            (.unknown, .unknown): return true
        default: return false
        }
    }
}

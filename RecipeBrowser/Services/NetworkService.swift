//
//  NetworkService.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/20/25.
//

import UIKit

protocol NetworkServiceProtocol {
    func handleRequest(for url: URL) async throws -> Data
}


final class NetworkService: NetworkServiceProtocol {
    enum Error: Swift.Error {
        case invalidURL
        case networkFailure(statusCode: Int)
        case unknown(Swift.Error)
    }
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func handleRequest(for url: URL) async throws(Error) -> Data {
        guard url.scheme == "http" || url.scheme == "https" else {
            throw Error.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                throw Error.networkFailure(statusCode: 0)
            }
            
            guard httpUrlResponse.statusCode == 200 else {
                throw Error.networkFailure(statusCode: httpUrlResponse.statusCode)
            }
            
            return data
        } catch let error as Error {
            throw error
        } catch {
            throw .unknown(error)
        }
    }
}

extension NetworkService.Error: Equatable {
    static func ==(lhs: NetworkService.Error, rhs: NetworkService.Error)  -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case let(.networkFailure(lCode), .networkFailure(rCode)): return lCode == rCode
        case let(.unknown(lError), .unknown(rError)): return lError.localizedDescription == rError.localizedDescription
        default: return false
        }
        
    }
}

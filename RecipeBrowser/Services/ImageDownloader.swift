//
//  ImageDownloader.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit

protocol ImageDownloadable {
    func fetchImage(from url: URL) async throws(Error) -> UIImage?
}

final class ImageDownloader: ImageDownloadable {
    enum Error: Swift.Error {
        case invalidURL
        case networkFailure(statusCode: Int)
        case imageDecodeFailure
        case unknown(Swift.Error)
    }
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchImage(from url: URL) async throws(Error) -> UIImage? {
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
            
            guard let image = UIImage(data: data) else {
                throw Error.imageDecodeFailure
            }
            return image
        } catch let error as Error {
            throw error
        } catch {
            throw .unknown(error)
        }
    }
}

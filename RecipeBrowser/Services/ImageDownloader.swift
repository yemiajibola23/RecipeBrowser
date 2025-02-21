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
        case imageDecodeFailure
        case network(NetworkService.Error)
    }
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchImage(from url: URL) async throws -> UIImage? {
        do {
            let data = try await networkService.handleRequest(for: url)
            guard let image = UIImage(data: data) else {
                throw Error.imageDecodeFailure
            }
            return image
        } catch let imageDownloadError as Error {
            throw imageDownloadError
        } catch {
            throw error
        }
    }
}

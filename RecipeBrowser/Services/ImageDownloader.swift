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
        case imageDecoding
        case network(NetworkService.Error)
        case unknown(Swift.Error)
    }
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchImage(from url: URL) async throws(Error) -> UIImage? {
        do {
            let data = try await networkService.handleRequest(for: url)
            guard let image = UIImage(data: data) else { throw Error.imageDecoding }
            return image
        } catch let networkError as NetworkService.Error {
            throw .network(networkError)
        } catch let selfError as ImageDownloader.Error {
            throw selfError
        }catch {
            throw .unknown(error)
        }
    }
}

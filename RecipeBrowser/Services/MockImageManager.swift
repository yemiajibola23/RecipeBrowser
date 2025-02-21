//
//  MockImageCacheManager.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import UIKit

class MockImageManager: ImageManagerProtocol {
        var mockImage: UIImage?
        var mockError: Error?
        
        func loadImage(from url: URL) async throws -> UIImage? {
            if let error = mockError { throw error }
            try? await Task.sleep(nanoseconds: 500_000_000)
            return mockImage
        }
        
        func clearCache() { mockImage = nil }
    }

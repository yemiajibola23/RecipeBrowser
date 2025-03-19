//
//  ImageCachable.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/18/25.
//

import UIKit

protocol ImageCachable {
    func saveImage(_ image: UIImage, for url: URL, dateSaved: Date)
    func loadImage(for url: URL) -> UIImage?
    func containsImage(for url: URL) -> Bool
    func clearCache()
    func cachePath(for url: URL) -> String
}

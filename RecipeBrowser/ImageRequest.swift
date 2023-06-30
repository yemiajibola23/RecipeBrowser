//
//  ImageRequest.swift
//  RecipeBrowser
//
//  Created by Yemi Ajibola on 6/30/23.
//

import Foundation

enum ImageRequest {
    case getImage(String)
}

extension ImageRequest: APIRequest {
    var url: String? {
        switch self {
        case .getImage(let thumb):
            return thumb
        }
    }
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        .get
    }
}

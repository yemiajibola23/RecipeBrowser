//
//  Cuisine.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/29/25.
//

import SwiftUI

enum Cuisine: String, CaseIterable, Codable, Identifiable {
    case american
    case british
    case canadian
    case malaysian
    case french
    case tunisian
    case italian
    case mexican
    case japanese
    case indian
    case unknown
    
    var id: String { rawValue }
    
    var displayName: String { rawValue.capitalized }
    
    var color: Color {
        switch self {
        case .american: return .mint
        case .british: return .blue
        case .malaysian: return .red
        case .canadian: return .cyan
        case .french: return .yellow
        case .tunisian: return .green
        case .italian: return .indigo
        case .mexican: return .orange
        case .japanese: return .purple
        case .indian: return .brown
        case .unknown: return .gray.opacity(0.6)
        }
    }
}

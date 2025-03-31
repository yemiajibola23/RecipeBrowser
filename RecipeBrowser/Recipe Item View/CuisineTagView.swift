//
//  CuisineTagView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/31/25.
//

import SwiftUI

struct CuisineTagView: View {
    var cuisine: Cuisine
    var body: some View {
        Text(cuisine.displayName.uppercased())
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(cuisine.color.opacity(0.1))
                            .foregroundStyle(cuisine.color)
        .clipShape(Capsule())    }
}

#Preview {
    CuisineTagView(cuisine: .american)
}

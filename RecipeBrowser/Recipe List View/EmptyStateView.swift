//
//  EmptyStateView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/22/25.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    var body: some View {
        VStack {
            ImageManager.emptyImage
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray.opacity(0.5))
            
            Text(message)
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(message: RecipeListViewModel.ErrorMessages.empty.rawValue)
}

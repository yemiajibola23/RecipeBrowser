//
//  RecipeItemView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeItemView: View {
    @Bindable var viewModel: RecipeItemViewModel
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedAsyncImage(viewModel: viewModel, imageKeyPath: \.smallImage, loadingKeyPath: \.isLoadingSmallImage, width: UIScreen.main.bounds.width * 0.9, height: 220, contentMode: .fill, loadingImageTask: { await viewModel.loadSmallImage() }, namespace: namespace)
            Text(viewModel.name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.horizontal, 10)
            Text(viewModel.cuisine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
        }
        .padding(.vertical, 8)
        .onAppear {
            print("✅ Recipe item view is rendered for \(viewModel.name)")
        }
    }
}

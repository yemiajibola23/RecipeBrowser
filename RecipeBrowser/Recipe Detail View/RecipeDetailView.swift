//
//  RecipeDetailView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/28/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let viewModel: RecipeItemViewModel
    
    var body: some View {
        CachedAsyncImage(viewModel: viewModel, imageKeyPath: \.largeImage, loadingKeyPath: \.isLoadingLargeImage, width: 300, height: 300, contentMode: .fill, loadingImageTask: { await viewModel.loadLargeImage() })
    }
}


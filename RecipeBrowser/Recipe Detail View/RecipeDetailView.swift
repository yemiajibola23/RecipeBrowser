//
//  RecipeDetailView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/28/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Bindable var viewModel: RecipeItemViewModel
    var namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                CachedAsyncImage(viewModel: viewModel, imageKeyPath: \.largeImage, loadingKeyPath: \.isLoadingLargeImage, width: nil, height: 250, contentMode: .fill, loadingImageTask: { await viewModel.loadLargeImage() }, namespace: namespace)
                    .frame(maxWidth: .infinity)
            }
        }
       
    }
}


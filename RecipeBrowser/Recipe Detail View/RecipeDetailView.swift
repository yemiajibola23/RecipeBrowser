//
//  RecipeDetailView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/28/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Bindable var viewModel: RecipeViewModel
    var namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    CachedAsyncImage(
                        viewModel: viewModel,
                        imageKeyPath: \.largeImage,
                        loadingKeyPath: \.isLoadingLargeImage,
                        width: nil,
                        height: 250,
                        contentMode: .fill,
                        loadingImageTask: { await viewModel.loadLargeImage() },
                        namespace: namespace)
                        .frame(maxWidth: .infinity)
                    
                    Text(viewModel.name)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                }
                
                CuisineTagView(cuisine: viewModel.cuisine)
                    .padding(.horizontal)
                
                if let youtubeURL = viewModel.youtubeURL {
                    YouTubePlayerView(videoURL: youtubeURL)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                }
            }
        }
       
    }
}



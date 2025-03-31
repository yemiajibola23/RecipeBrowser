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
                ZStack(alignment: .topTrailing) {
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
                    
                    if let url = viewModel.sourceURL {
                        Link(destination: url) {
                            ImageManager.linkImage
                                .font(.system(size: 25, weight: .semibold))
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .padding(12)
                        .shadow(radius: 2)
                    }
                }
               
                Text(viewModel.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
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



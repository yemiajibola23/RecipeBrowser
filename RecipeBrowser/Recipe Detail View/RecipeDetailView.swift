//
//  RecipeDetailView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/28/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Bindable var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack(alignment: .topTrailing) {
                    ZStack(alignment: .bottom) {
                        CachedAsyncImage(
                            viewModel: viewModel,
                            imageKeyPath: \.largeImage,
                            loadingKeyPath: \.isLoadingLargeImage,
                            width: nil,
                            height: 250,
                            cornerRadius: 0,
                            contentMode: .fill,
                            loadingImageTask: { await viewModel.loadLargeImage() })
                        .frame(maxWidth: .infinity)
    
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    }
                    .aspectRatio(3/2, contentMode: .fit)

                    if let url = viewModel.sourceURL {
                        Link(destination: url) {
                            ImageManager.linkImage
                                .font(.system(size: 25, weight: .semibold))
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .padding(12)
                        .padding(.top, 20)
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
                    Text("Video Tutorial")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    YouTubePlayerView(videoURL: youtubeURL)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                        .overlay (
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                    
                }
            }
        }
        
    }
}



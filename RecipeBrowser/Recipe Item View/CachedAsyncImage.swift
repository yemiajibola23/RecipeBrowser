//
//  CachedAsyncImage.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    @Bindable var viewModel: RecipeItemViewModel

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .foregroundStyle(.primary)
            } else if viewModel.isLoading {
                ShimmerView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            } else {
                ImageManager.placeholderImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        .id(UUID())
        .onAppear {
            print("✅ CachedAsyncImage appeared")
            Task {
                print("🟢 Attempting to call loadImage()")
                await viewModel.loadImage()
                print("🟢 loadImage() has finished executing")
                
            }
        }
    }
}
//
//#Preview {
//    CachedAsyncImage()
//}

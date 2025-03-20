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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .foregroundStyle(.primary)
            } else if viewModel.isLoading {
                ShimmerView()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ImageManager.placeholderImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        .onAppear {
//            print("✅ CachedAsyncImage appeared")
            Task {
//                print("🟢 Attempting to call loadImage()")
                await viewModel.loadImage()
//                print("🟢 loadImage() has finished executing")
                
            }
        }
    }
}
//
//#Preview {
//    CachedAsyncImage()
//}

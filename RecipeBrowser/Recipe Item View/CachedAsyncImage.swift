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
        AsyncImageView(image: viewModel.image, isLoading: viewModel.isLoading, errorMessage: viewModel.errorMessage)
            .id(viewModel.image)
            .onAppear {
//                print("✅ CachedAsyncImage appeared")
                Task {
//                    print("🟢 Attempting to call loadImage()")
                    await viewModel.loadImage()
//                    print("🟢 loadImage() has finished executing")
                    
                }
            }
    }
}
//
//#Preview {
//    CachedAsyncImage()
//}

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
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
            } else if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .backgroundStyle(Color.red)
                    .multilineTextAlignment(.center)
            } else {
                Text("No Image available.")
            }
        }
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

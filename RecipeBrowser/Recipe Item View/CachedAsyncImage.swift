//
//  CachedAsyncImage.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    @Bindable var viewModel: RecipeViewModel
    let imageKeyPath: KeyPath<RecipeViewModel, UIImage?>
    let loadingKeyPath: KeyPath<RecipeViewModel, Bool>
    let width: CGFloat?
    let height: CGFloat?
    let contentMode: ContentMode
    let loadingImageTask: () async -> Void
    let namespace: Namespace.ID

    var body: some View {
        ZStack {
            if let image = viewModel[keyPath: imageKeyPath] {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .applyMatchingGeometryEffect(id: viewModel.recipeID, namespace: namespace)
                    .foregroundStyle(.primary)
                    .opacity(1)
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.5), value: image)
            } else if viewModel[keyPath: loadingKeyPath] {
                ShimmerView()
                    .frame(width: width, height: height)
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
                    .frame(width: width, height: height)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.gray.opacity(0.5))
            }
        }
        .onAppear {
//            print("✅ CachedAsyncImage appeared")
            Task {
//                print("🟢 Attempting to call loadImage()")
                await loadingImageTask()
//                print("🟢 loadImage() has finished executing")
                
            }
        }
    }
}

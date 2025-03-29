//
//  CachedAsyncImage.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/19/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    @Bindable var viewModel: RecipeItemViewModel
    let imageKeyPath: KeyPath<RecipeItemViewModel, UIImage?>
    let loadingKeyPath: KeyPath<RecipeItemViewModel, Bool>
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
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .applyMatchingGeometryEffect(id: viewModel.recipeID, namespace: namespace)
                    .foregroundStyle(.primary)
                    .opacity(1)
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.5), value: image)
            } else if viewModel[keyPath: loadingKeyPath] {
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
                await loadingImageTask()
//                print("🟢 loadImage() has finished executing")
                
            }
        }
    }
}

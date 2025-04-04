//
//  RecipeItemView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeItemView: View {
    @Bindable var viewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedAsyncImage(viewModel: viewModel, imageKeyPath: \.smallImage, loadingKeyPath: \.isLoadingSmallImage, width: UIScreen.main.bounds.width * 0.9, height: 220, cornerRadius: 25.0, contentMode: .fill, loadingImageTask: { await viewModel.loadSmallImage() })
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                }
                .shadow(color: .black, radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                CuisineTagView(cuisine: viewModel.cuisine)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
        )
        .padding(.horizontal)
        .onAppear {
            print("✅ Recipe item view is rendered for \(viewModel.name)")
        }
    }
}

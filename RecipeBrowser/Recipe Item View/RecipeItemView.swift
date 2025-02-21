//
//  RecipeItemView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeItemView: View {
    @Bindable var viewModel: RecipeItemViewModel
    
    var body: some View {
        VStack {
            CachedAsyncImage(viewModel: viewModel)                
            Text(viewModel.name)
                .font(.title)
                .bold()
            Text(viewModel.cuisine)
                .font(.title2)
        }
    }
}

#Preview {
    RecipeItemView(viewModel: RecipeItemViewModel(recipe: .mock.first!, imageManager: MockImageManager()))
}

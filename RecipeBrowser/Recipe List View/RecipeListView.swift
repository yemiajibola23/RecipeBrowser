//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeListView: View {
    @Bindable var viewModel: RecipeListViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($recipes) { recipe in
//                    RecipeItemView(recipe: recipe)
                }
            }
        }
        .padding()
    }
}

#Preview {
    RecipeListView()
}

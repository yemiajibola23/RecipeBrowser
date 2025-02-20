//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeListView: View {
    @State var recipes = Recipe.mock
    
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

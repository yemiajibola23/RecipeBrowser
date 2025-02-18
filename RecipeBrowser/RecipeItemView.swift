//
//  RecipeItemView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeItemView: View {
    @Binding var recipe: Recipe
    var body: some View {
        VStack {
            Image("placeholder-meal")
                .resizable()
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            Text(recipe.name)
                .font(.title)
                .bold()
            Text(recipe.cuisine)
                .font(.title2)
        }
    }
}

#Preview {
    RecipeItemView(recipe: .constant(.mock.first!))
}

//
//  RecipeItemView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeItemView: View {
    var body: some View {
        VStack {
            Image("placeholder-meal")
                .resizable()
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            Text("Meal 1")
                .font(.title)
                .bold()
            Text("Cuisine")
                .font(.title2)
        }
    }
}

#Preview {
    RecipeItemView()
}

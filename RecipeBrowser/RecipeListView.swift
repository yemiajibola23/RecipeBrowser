//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/17/25.
//

import SwiftUI

struct RecipeListView: View {
    var body: some View {
        NavigationStack {
            RecipeItemView()
        }
        .padding()
    }
}

#Preview {
    RecipeListView()
}

//
//  RecipeCardView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/13/25.
//

import SwiftUI

struct RecipeCardView: View {
    @State private var isFlipped = false
    let viewModel: RecipeItemViewModel
   
    var body: some View {
        ZStack {
            if isFlipped {
                // Back of card
                VStack {
                    Text("\(viewModel.name)")
                        .font(.title2)
                        .bold()
                    Text("Cuisine: \(viewModel.cuisine)")
                    Text("YouTube: \(viewModel.youtubeLink)")
                    Text("Website: \(viewModel.sourceLink)")
                        .padding()
                    Spacer()
                    Button("Flip Back") {
                        withAnimation(.easeInOut) {
                            isFlipped.toggle()
                        }
                    }
                    .padding()
                }
                .frame(width: 200, height: 300)
                .background(Color.orange.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            } else {
                // Front of card
                ZStack {
                    CachedAsyncImage(viewModel: viewModel, width: 200, height: 300)
                    
                    VStack {
                        Text(viewModel.name)
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .bold()
                        Text(viewModel.cuisine)
                            .font(.title2)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                }
                .shadow(radius: 5)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isFlipped.toggle()
            }
        }
    }
}

//#Preview {
//    RecipeCardView()
//}

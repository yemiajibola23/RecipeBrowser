//
//  AsyncImageView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/21/25.
//

import SwiftUI

struct AsyncImageView: View {
    let image: UIImage?
    let isLoading: Bool
    let errorMessage: String?
    let placeholder =  UIImage(named: "placeholder-meal")!
    
    var body: some View {
        ZStack {
            Image(uiImage: image ?? placeholder)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .foregroundStyle(image == nil ? .gray.opacity(0.5) : .primary)
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
        }
    }
}
 

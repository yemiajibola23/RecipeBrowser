//
//  ShimmerView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/21/25.
//


import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = 0.0

    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.1),
                        Color.gray.opacity(0.3)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 300, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .overlay(
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(Color.gray.opacity(0.2))
            )
            .mask(
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.4)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: phase)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300 // Moves shimmer effect across the view
                }
            }
    }
}

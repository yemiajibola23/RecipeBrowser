//
//  ErrorView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 2/22/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.red.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10))
           
            Button(action: retryAction) {
                Text("Retry")
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

//#Preview {
//    ErrorView()
//}

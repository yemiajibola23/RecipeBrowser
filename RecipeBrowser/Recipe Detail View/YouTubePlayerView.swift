//
//  YouTubePlayerView.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/29/25.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.configuration.allowsInlineMediaPlayback = true
        
        return webView
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: videoURL)
        
        uiView.load(request)
    }
}

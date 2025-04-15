//
//  LottieView.swift
//  Thancho2
//
//  Created by 박지희 on 4/15/25.
//

import SwiftUI
import WebKit

//struct LottieView: UIViewRepresentable {
//    
//    let fileName: String
//    let loopMode: LottieLoopMode
//    
//    typealias UIBiewType = UIView
//    
//    func makeUIView(context: Context) -> some UIView {
//        let animationView = LottieAnimationView(name: fileName)
//        animationView.loopMode = loopMode
//        animationView.backgroundColor = .white
//        animationView.play()
//        return animationView
//    }
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        
//    }
//}

struct GitView: UIViewRepresentable {
    let fileName: String
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        let url = Bundle.main.url(forResource: fileName, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8",baseURL: url.deletingLastPathComponent())
        return webView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview(body: {
    GitView(fileName: "Thancho")
})

//
//  LottieView.swift
//  Thancho2
//
//  Created by 박지희 on 4/15/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let fileName: String
    let loopMode: LottieLoopMode
    
    typealias UIBiewType = UIView
    
    func makeUIView(context: Context) -> some UIView {
        let animationView = LottieAnimationView(name: fileName)
        animationView.loopMode = loopMode
        animationView.backgroundColor = .white
        animationView.play()
        return animationView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

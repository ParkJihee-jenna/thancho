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

    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: fileName)
        animationView.frame = view.bounds
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        animationView.loopMode = loopMode
        animationView.play()

        view.addSubview(animationView)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 비워도 OK
    }
}

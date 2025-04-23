//
//  LottieView.swift
//  Thancho2
//
//  Created by 박지희 on 4/15/25.
//
//
import SwiftUI  // SwiftUI: iOS 앱의 UI를 구성하는 프레임워크
import Lottie   // Lottie: 애니메이션(.json)을 재생할 수 있게 도와주는 프레임워크


struct LottieView: UIViewRepresentable {//SwiftUI는 직접 Lottie를 사용할 수 없기 때문에, UIViewRepresentable을 통해 UIKit 뷰(LottieAnimationView)를 SwiftUI에서 사용할 수 있게 만들어주는 구조체입니다.
    let fileName: String
    let loopMode: LottieLoopMode       // 애니메이션 반복 여부

    typealias UIViewType = UIView //SwiftUI에서 사용할 UIKit 뷰의 타입을 UIView로 지정. 기본적인 UIView를 사용.

    func makeUIView(context: Context) -> UIView { //SwiftUI가 이 뷰를 처음 만들 때 호출되는 함수. UIKit의 UIView를 생성하고 설정.
        let view = UIView(frame: .zero) // 기본 UIView 하나 생성 (애니메이션을 올릴 공간)
        let animationView = LottieAnimationView(name: fileName) //Lottie에서 제공하는 애니메이션 뷰를 생성하면서, 우리가 전달한 fileName을 사용해 .json 파일을 로드합니다.
        animationView.frame = view.bounds  // 부모 뷰의 크기와 같게 설정
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight] //화면 크기에 따라 자동으로 크기를 조절할 수 있도록 설정합니다.
        animationView.loopMode = loopMode  // 반복 설정 (한 번만 재생할지, 계속 반복할지 등)
        animationView.play()              // 애니메이션 실행!
        view.addSubview(animationView)    // 부모 뷰에 애니메이션 뷰 추가
        return view                       // 완성된 뷰를 SwiftUI로 반환
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        // 비워도 OK (애니메이션은 한 번만 실행되므로 업데이트 필요 없음)
    }
}

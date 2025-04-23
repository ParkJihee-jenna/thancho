//
//  ContentView.swift
//  Thancho
//
//  Created by 박지희 on 4/14/25.
//

import SwiftUI  // SwiftUI 프레임워크: iOS 앱의 UI를 만들기 위한 기본 도구

// ContentView: 앱에서 가장 먼저 보여지는 화면 (기본 View)
struct ContentView: View {
    var body: some View {
        VStack { // 세로로 뷰를 쌓는 컨테이너 (Vertical Stack)
        
            // Lottie 애니메이션을 화면에 표시하는 커스텀 뷰
            // - fileName: 애니메이션 JSON 파일 이름 ("Thancho.json")
            // - loopMode: 애니메이션 반복 여부 (.playOnce는 한 번만 재생)
            LottieView(fileName: "Thancho", loopMode: .playOnce)
        }
        .padding() // VStack 전체에 여백(padding)을 줌 (기본값은 모든 방향 16pt)
    }
}

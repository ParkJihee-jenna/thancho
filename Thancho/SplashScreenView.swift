//
//  SplashScreenView.swift
//  Thancho2
//
//  Created by 박지희 on 4/19/25.
//
import SwiftUI  // SwiftUI 프레임워크 불러오기 (앱 UI를 만들기 위한 도구)

struct SplashScreenView: View { //앱이 실행되자마자 가장 먼저 보여주는 로딩 화면 또는 인트로 화면.
    @State private var isActive = false //화면 전환을 제어하는 변수. 처음엔 false로 시작 → 일정 시간이 지나면 true가 되어 메인 화면으로 전환됨.

    var body: some View {
        NavigationStack { //SwiftUI에서 여러 화면을 오갈 수 있게 해주는 화면 이동 전용 스택 구조. 이 안에서 조건에 따라 ContentView() 또는 MainView()를 보여줄 수 있음.
            ZStack { //ZStack은 뷰를 겹쳐서 보여주는 구조. 여기선 조건에 따라 하나의 뷰만 보이게 하니까 약간의 "전환 애니메이션" 느낌을 줄 수 있음.
                if isActive {
                    MainView()  // 시간이 지나면 MainView로 전환됨
                } else {
                    ContentView()  // 처음 앱 실행 시 보여줄 애니메이션 화면
                        .onAppear { //ContentView가 화면에 나타나자마자 다음 동작을 예약.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) { //앱 실행 후 2.8초 기다렸다가 아래 코드를 실행
                                withAnimation {
                                    isActive = true //isActive = true가 되면서 화면이 전환되고, withAnimation을 사용해서 전환이 부드럽게 되도록 처리
                                }
                            }
                        }
                }
            }
        }
    }
}


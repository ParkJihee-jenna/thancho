//
//  Thancho2App.swift
//  Thancho2
//
//  Created by 박지희 on 4/14/25.

import SwiftUI     // SwiftUI 프레임워크: 앱 UI를 구성하는 데 사용
import SwiftData   // SwiftData 프레임워크: 데이터를 저장하고 관리하기 위한 도구

@main
struct Thancho2App: App { //@main은 이 구조체가 앱의 시작점임을 알려주는 표시예요. 앱을 실행하면 여기서부터 시작돼요! Thancho2App은 앱 이름에 해당하며, App 프로토콜을 따르고 있어요.
    var body: some Scene { //SwiftUI에서는 Scene이란 화면의 기본 단위예요. 하나의 Scene 안에 여러 개의 화면(View)을 넣을 수 있어요.
        WindowGroup { //WindowGroup은 하나의 창을 열어주는 컨테이너예요. iPhone에서는 한 번에 하나의 창이 열리지만, iPad나 Mac에선 여러 개 열릴 수도 있어요.
            SplashScreenView() //앱을 실행했을 때 가장 처음 보여줄 화면이에요! 여기서는 인트로 애니메이션이 나오는 SplashScreenView를 사용하고 있어요.
        }
        .modelContainer(for: [Journal.self]) // ✅ SwiftData 연결 이 줄이 중요한데요! SwiftData의 **저장 공간(데이터베이스)**을 연결해주는 코드예요.
    }
}

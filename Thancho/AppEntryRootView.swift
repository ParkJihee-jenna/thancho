//
//  AppEntryRootView.swift
//  Thancho
//
//  Created by 박지희 on 4/19/25.
//

import SwiftUI

struct AppEntryRootView: View { //이 구조체는 SwiftUI에서 사용하는 기본 화면(View) 앱이 시작되면 가장 먼저 이 화면이 표시.
    var body: some View {
        NavigationStack { //여러 화면 간 이동을 가능하게 해주는 SwiftUI의 탐색 뷰 컨테이너입니다.
            //이 안에 있는 뷰들은 다음 화면으로 밀거나 뒤로 돌아갈 수 있다
            SplashScreenView()
        }
    }
}


//
//  MainAppEntryView.swift
//  Thancho2
//
//  Created by 박지희 on 4/19/25.
//

import SwiftUI

struct AppEntryRootView: View {
    var body: some View {
        NavigationStack {
            SplashScreenView() // 로티 애니 끝나면 MainView로 전환
        }
    }
}

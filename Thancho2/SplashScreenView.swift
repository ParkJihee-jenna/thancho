//
//  SplashScreenView.swift
//  Thancho2
//
//  Created by 박지희 on 4/19/25.
//
import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        NavigationStack { // ✅ 여기서 감싸주면 된다!
            ZStack {
                if isActive {
                    MainView() // 이건 내부에 NavigationView 없어야 함!
                } else {
                    ContentView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }
                }
            }
        }
    }
}
#Preview {
    SplashScreenView()
}
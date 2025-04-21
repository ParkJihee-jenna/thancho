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
        NavigationStack { 
            ZStack {
                if isActive {
                    MainView() 
                } else {
                    ContentView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
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
//#Preview {
//    SplashScreenView()
//}

//
//  MainView.swift
//  Thancho2
//
////  Created by 박지희 on 4/18/25.
//
//
//import SwiftUI
//
//struct MainView: View {
//    let buttonFrameWidth: CGFloat = 200
//
//    // 흔들림 효과를 위한 상태 변수
//    @State private var wiggleWrite = false
//    @State private var wiggleView = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Image("MainView")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//
//                ZStack {
//                    // Thancho 쓰기 버튼
//                    NavigationLink(destination: {
//                        JournalEntryView().navigationBarBackButtonHidden(true)
//                    }) {
//                        Text("Thancho 쓰기")
//                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 30))
//                            .foregroundColor(.black)
//                            .frame(width: buttonFrameWidth, alignment: .trailing)
//                            .rotationEffect(.degrees(-19.76))
//                            .offset(x: wiggleWrite ? -2 : 2) // 🔄 흔들림 오프셋
//                            .animation(
//                                Animation.easeInOut(duration: 0.4)
//                                    .repeatForever(autoreverses: true),
//                                value: wiggleWrite
//                            )
//                    }
//                    .onAppear {
//                        wiggleWrite = true
//                    }
//                    .position(x: 252, y: 271.8)
//
//                    // Thancho 모아보기 버튼
//                    NavigationLink(destination: {
//                        JournalCardExampleView().navigationBarBackButtonHidden(true)
//                    }) {
//                        Text("Thancho 모아보기")
//                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 30))
//                            .foregroundColor(Color(hex: "#FAFAFA"))
//                            .frame(width: buttonFrameWidth, alignment: .trailing)
//                            .rotationEffect(.degrees(21.97))
//                            .offset(x: wiggleView ? 2 : -2)
//                            .animation(
//                                Animation.easeInOut(duration: 0.4)
//                                    .repeatForever(autoreverses: true),
//                                value: wiggleView
//                            )
//                    }
//                    .onAppear {
//                        wiggleView = true
//                    }
//                    .position(x: 252, y: 528.8)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//
//        let r, g, b: UInt64
//        (r, g, b) = (
//            (int >> 16) & 0xFF,
//            (int >> 8) & 0xFF,
//            int & 0xFF
//        )
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue: Double(b) / 255,
//            opacity: 1
//        )
//    }
//}
//
import SwiftUI

struct MainView: View {
    let buttonFrameWidth: CGFloat = 200
    
    @State private var wiggleAngleWrite: Double = 0
    @State private var wiggleAngleView: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("MainView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ZStack {
                    // Thancho 쓰기 버튼
                    NavigationLink(destination: {
                        JournalEntryView().navigationBarBackButtonHidden(true)
                    }) {
                        Text("Thancho 쓰기")
                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 30))
                            .foregroundColor(.black)
                            .frame(width: buttonFrameWidth, alignment: .trailing)
                            .rotationEffect(.degrees(-19.76 + wiggleAngleWrite)) // ✅ 기본 기울기에 덧붙임
                    }
                    .onAppear {
                        wiggleButton { angle in wiggleAngleWrite = angle }
                    }
                    .position(x: 252, y: 271.8)
                    
                    // Thancho 모아보기 버튼
                    NavigationLink(destination: {
                        JournalCardExampleView().navigationBarBackButtonHidden(true)
                    }) {
                        Text("Thancho 모아보기")
                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 30))
                            .foregroundColor(Color(hex: "#FAFAFA"))
                            .frame(width: buttonFrameWidth, alignment: .trailing)
                            .rotationEffect(.degrees(21.97 + wiggleAngleView)) // ✅ 기본 기울기에 덧붙임
                    }
                    .onAppear {
                        wiggleButton { angle in wiggleAngleView = angle }
                    }
                    .position(x: 252, y: 528.8)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func wiggleButton(setAngle: @escaping (Double) -> Void) {
        let angles: [Double] = [6, -6, 4, -4, 2, -2, 1, -1, 0]

        for (i, angle) in angles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.112) {
                withAnimation(.easeInOut(duration: 0.112)) {
                    setAngle(angle)
                }
            }
        }
    }



}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        (r, g, b) = (
            (int >> 16) & 0xFF,
            (int >> 8) & 0xFF,
            int & 0xFF
        )

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}


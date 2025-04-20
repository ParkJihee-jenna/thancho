//
//  MainView.swift
//  Thancho2
//
//  Created by 박지희 on 4/18/25.

import SwiftUI

struct MainView: View {
    let buttonFrameWidth: CGFloat = 200

    var body: some View {
        NavigationStack {
            ZStack {
                // 전체 배경 이미지
                Image("MainView")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Thancho 쓰기 버튼
                NavigationLink(destination: JournalEntryView().navigationBarBackButtonHidden(true)) {
                    Text("Thancho 쓰기")
                        .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 34))
                        .foregroundColor(.black)
                        .frame(width: buttonFrameWidth, alignment: .trailing)
                        .rotationEffect(.degrees(-21.5))
                }
                .position(x: 252, y: 271.8)

                // Thancho 모아보기 버튼
                NavigationLink(destination: JournalCardExampleView().navigationBarBackButtonHidden(true)) {
                    Text("Thancho 모아보기")
                        .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 34))
                        .foregroundColor(Color(hex: "#FAFAFA"))
                        .frame(width: buttonFrameWidth, alignment: .trailing)
                        .rotationEffect(.degrees(22.14))
                }
                .position(x: 252, y: 535.8)
            }
        }
        .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨기기
    }
}

// HEX Color Extension
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

#Preview {
    MainView()
}

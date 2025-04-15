////  WritingView.swift
////  Thancho2
////
////  Created by 박지희 on 4/15/25.
//
//
import SwiftUI

struct JournalEntryView: View {
    @State private var currentDate: Date = Date() // 현재 날짜 상태
    @State private var entryText: String = "" // 텍스트 입력 상태
    @State private var showCalendar: Bool = false // 캘린더 팝업 표시 여부

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 날짜 포맷
        return formatter.string(from: currentDate)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 상단 바
                HStack {
                    // 뒤로 가기 버튼
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                            .padding(.top, 10)
                            .padding(.leading, 12)
                    }

                    Spacer()

                    // 날짜 + 캘린더 버튼
                    VStack(spacing: 4) {
                        Button(action: {
                            withAnimation {
                                showCalendar.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                                    .padding(.top, 10)
                                Text(formattedDate)
                                    .font(.custom("NanumYuniDdingDdangDdingDdang", size: 32)) // 날짜 글씨 크기 32
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    Spacer()

                    // 저장 버튼
                    Button(action: {
                        print("저장된 내용: \(entryText)")
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                            .padding(.top, 5)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                // 글쓰기 배경 - Rectangle 적용
                ZStack(alignment: .topLeading) {
//                    Rectangle()
//                        .foregroundColor(.clear) // 투명한 기본 색상
//                        .frame(width: 353, height: 560) // 크기 설정
//                        .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2)) // 배경색과 투명도
//                        .cornerRadius(20) // 코너 반경
//                        .padding(.top, 5)
//                    
//                    // TextEditor 입력 박스
//                    TextEditor(text: $entryText)
//                        .padding()
//                        .frame(width: 353, height: 535)
//                        .background(Color.clear)
//                        .font(.custom("NanumYuniDdingDdangDdingDdang", size: 24)) // 작성란 글씨 크기 24
//                        .opacity(entryText.isEmpty ? 1 : 0.01)
//                        .padding(.top, 5)

                    TextEditor(text: $entryText)
                        .background(Color(UIColor(red: 0.5, green: 0.69, blue: 0.84, alpha: 0.2)))
                        .cornerRadius(20)
                        .frame(width: 353, height: 560)
                        .padding(.top, 5)
                                 
                    // 플레이스홀더 텍스트
                    if entryText.isEmpty {
                        Text("당신의 마음에 울린 감사의 메아리를 적어보아요")
                            .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 24)) // 작성란 플레이스홀더 크기 24
                            .multilineTextAlignment(.center) // 중앙 정렬
                            .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42)) // 색상 설정
                            .padding(.horizontal, 20) // 텍스트가 영역 안에 잘 들어오도록 설정
                            .padding(.top, 20) // 위쪽 여백 추가
                    }
                }
                .padding(.top, 20)

                Spacer()

                // 하단 버튼
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "camera")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                    }

                    Button(action: {}) {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                    }
                }
                .padding(.bottom, 30)
            }

            // 🎯 캘린더 팝업
            if showCalendar {
                ZStack {
                    // 팝업용 반투명 배경
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            // 배경을 클릭했을 때 캘린더 닫기
                            withAnimation {
                                showCalendar = false
                            }
                        }

                    // 캘린더 팝업
                    VStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 3)
                            .frame(maxWidth: 300, maxHeight: 320)
                            .overlay(
                                DatePicker(
                                    "",
                                    selection: $currentDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .padding()
                            )
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView()
    }
}

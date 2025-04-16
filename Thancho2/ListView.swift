////
////  ListView.swift
////  Thancho2
////
//////  Created by 박지희 on 4/16/25.
import SwiftUI

struct JournalCardExampleView: View {

    // 🔹 일기 카드 데이터 입력: 날짜, 글, 이미지 포함
    struct JournalCard {
        let date: String
        let content: String
        let images: [UIImage] // 여러 이미지를 포함
    }

    // 🔸 샘플 데이터
    @State private var journalCards: [JournalCard] = [
        JournalCard(
            date: "2025. 04. 09 수요일",
            content: """
            1. 애정하는 사람들과 맛있는 점심 먹을 수 있음에 감사
            2. 벚꽃이 너무 아름다워서 보는 눈이 즐거워서 감사
            3. 좋은 팀원들을 만나서 행복하게 프로젝트해서 감사
            """,
            images: []
        ),
        JournalCard(
            date: "2025. 04. 10 목요일",
            content: """
            1. 맑은 공기를 마실 수 있어서 감사
            2. 길을 가다 고양이가 나한테 다가와줘서 감사
            3. 두 발로 걸어다닐 수 있어서 감사
            """,
            images: [UIImage(systemName: "photo")!]
        ),
        JournalCard(
            date: "2025. 04. 11 금요일",
            content: """
            1. 맛집을 발견해서 감사
            2. 사장님이 너무나도 친절하게 대해주셔서 감사
            3. 부모님이 건강하셔서 감사
            """,
            images: []
            ),
        JournalCard(
            date: "2025. 04. 12 토요일",
            content: """
            1. 언니가 힘내라고 용돈을 보내줘서 감사
            2. 오빠가 건강하라고 유산균을 보내줘서 감사
            3. 오랜만에 악기 연습을 할 수 있어서 감사
            """,
            images: [
                UIImage(systemName: "photo")!,
                UIImage(systemName: "photo.fill")!,
                UIImage(systemName: "photo")!,
                UIImage(systemName: "photo.fill")!
            ]
        ),
        JournalCard(
            date: "2025. 04. 13 일요일",
            content: """
            1. 맘에 드는 옷을 살 수 있어서 감사
            2. 보타가 가습기를 빌려주어서 감사
            3. 행복하다고 느낄 수 있어서 감사
            """,
            images: [UIImage(systemName: "photo")!]
        )
        
    ]

    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var isDatePickerVisible: Bool = false // 팝업 여부

    @State private var showImageViewer: Bool = false
    @State private var selectedImageForViewer: UIImage? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // 배경색
                Color.white.edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // 🔹 상단 버튼
                    HStack {
                        // 뒤로 가기 버튼
                        Button(action: {
                            print("뒤로 가기")
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.button)
                        }

                        Spacer()

                        // 📅 날짜 선택 버튼
                        Button(action: {
                            withAnimation {
                                isDatePickerVisible.toggle()
                            }
                        }) {
                            Text("\(String(selectedYear)) \(monthFormatter(selectedMonth))")
                                .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 32))

                                .foregroundColor(.black)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20) // 양 옆 마진

                    // 🔹 리스트: ScrollView
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(journalCards.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 10) {
                                    // 날짜
                                    Text(journalCards[index].date)
                                        .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 24))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)

                                    // 내용
                                    Text(journalCards[index].content)
                                        .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 22))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)

                                    // 이미지 프리뷰
                                    if !journalCards[index].images.isEmpty {
                                        HStack(spacing: 8) {
                                            ForEach(Array(journalCards[index].images.prefix(3).enumerated()), id: \.offset) { _, image in
                                                ZStack {
                                                    // 이미지
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .frame(width: 40, height: 40) // 크기를 60x60으로 설정
                                                        .cornerRadius(8)
                                                        .onTapGesture {
                                                            selectedImageForViewer = image
                                                            showImageViewer = true
                                                        }

                                                    // 투명한 오버레이 (20% 투명도)
                                                    Color.black.opacity(0.2)
                                                        .frame(width: 40, height: 40)
                                                        .cornerRadius(8)
                                                }
                                            }

                                            // 추가 이미지 표시 ("+N")
                                            if journalCards[index].images.count > 3 {
                                                ZStack {
                                                    Color.black.opacity(0.5)
                                                        .frame(width: 40, height: 40)
                                                        .cornerRadius(8)

                                                    Text("+\(journalCards[index].images.count - 3)")
                                                        .foregroundColor(.white)
                                                        .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 20))
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 24) // 개별 카드의 좌우 마진
                                .padding(.vertical, 18)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2)) // 카드 배경색
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20) // 카드 간 마진 추가
                    }

                    Spacer()
                }

                // 🔹 년/월 선택 팝업
                if isDatePickerVisible {
                    VStack(spacing: 16) {
                        Spacer()

                        VStack {
                            Picker("년도 선택", selection: $selectedYear) {
                                ForEach(2020...2030, id: \.self) { year in
                                    Text("\(String(year))").tag(year)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .labelsHidden()

                            Picker("월 선택", selection: $selectedMonth) {
                                ForEach(1...12, id: \.self) { month in
                                    Text(monthFormatter(month)).tag(month)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .labelsHidden()
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .padding()

                        Button(action: {
                            withAnimation {
                                isDatePickerVisible.toggle()
                            }
                        }) {
                            Text("확인")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                    }
                    .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                    .transition(.opacity)
                }
            }
            .sheet(isPresented: $showImageViewer) {
                if let selected = selectedImageForViewer {
                    ZStack {
                        Color.black.ignoresSafeArea()
                        Image(uiImage: selected)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        Button(action: {
                            showImageViewer = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .padding()
                        }
                    }
                }
            }
        }
    }

    private func monthFormatter(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let date = Calendar.current.date(from: DateComponents(year: 2025, month: month))!
        return formatter.string(from: date)
    }
}

struct JournalCardExampleView_Previews: PreviewProvider {
    static var previews: some View {
        JournalCardExampleView()
    }
}


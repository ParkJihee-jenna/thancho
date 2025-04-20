//////////
//////////  JournalCardExampleView
//////////  Thancho2
//////////
////////////  Created by 박지희 on 4/16/25.
//
//import SwiftUI
//import SwiftData
//
//struct JournalCardExampleView: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) private var modelContext
//
//    @Query(sort: [SortDescriptor(\Journal.date, order: .reverse)]) var journals: [Journal]
//
//    // 🔹 일기 카드 데이터 입력: 날짜, 글, 이미지 포함
//    struct JournalCard: Identifiable {
//        let id = UUID()
//        let date: String
//        let content: String
//        let images: [UIImage] // 여러 이미지를 포함
//    }
//
//    // 샘플 데이터
//    @State private var journalCards: [JournalCard] = [
//        JournalCard(
//                    date: "2025. 04. 09 수요일",
//                    content: """
//                    1. 애정하는 사람들과 맛있는 점심 먹을 수 있음에 감사
//                    2. 벚꽃이 너무 아름다워서 보는 눈이 즐거워서 감사
//                    3. 좋은 팀원들을 만나서 행복하게 프로젝트해서 감사
//                    """,
//                    images: []
//                ),
//                JournalCard(
//                    date: "2025. 04. 10 목요일",
//                    content: """
//                    1. 맑은 공기를 마실 수 있어서 감사
//                    2. 길을 가다 고양이가 나한테 다가와줘서 감사
//                    3. 두 발로 걸어다닐 수 있어서 감사
//                    """,
//                    images: [UIImage(systemName: "photo")!]
//                ),
//                JournalCard(
//                    date: "2025. 04. 11 금요일",
//                    content: """
//                    1. 맛집을 발견해서 감사
//                    2. 사장님이 너무나도 친절하게 대해주셔서 감사
//                    3. 부모님이 건강하셔서 감사
//                    """,
//                    images: []
//                    ),
//                JournalCard(
//                    date: "2025. 04. 12 토요일",
//                    content: """
//                    1. 언니가 힘내라고 용돈을 보내줘서 감사
//                    2. 오빠가 건강하라고 유산균을 보내줘서 감사
//                    3. 오랜만에 악기 연습을 할 수 있어서 감사
//                    """,
//                    images: [
//                        UIImage(systemName: "photo")!,
//                        UIImage(systemName: "photo.fill")!,
//                        UIImage(systemName: "photo")!,
//                        UIImage(systemName: "photo.fill")!
//                    ]
//                ),
//                JournalCard(
//                    date: "2025. 04. 13 일요일",
//                    content: """
//                    1. 맘에 드는 옷을 살 수 있어서 감사
//                    2. 보타가 가습기를 빌려주어서 감사
//                    3. 행복하다고 느낄 수 있어서 감사
//                    """,
//                    images: [UIImage(systemName: "photo")!]
//                )
//        
//            ]
//    
//    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
//    @State private var isDatePickerVisible: Bool = false
//    @State private var showImageViewer: Bool = false
//    @State private var selectedImageForViewer: UIImage? = nil
//    @State private var expandedMenuId: UUID? = nil // 메뉴를 특정 카드에만 표시하기 위한 상태
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // 배경 이미지 및 그라데이션
//                ZStack {
//                    Image("Rectangle 17")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 358, height: 741)
//                    
//                    LinearGradient(
//                        stops: [
//                            Gradient.Stop(color: Color(red: 0.98, green: 0.98, blue: 0.98), location: 0.00),
//                            Gradient.Stop(color: Color(red: 0.88, green: 0.88, blue: 0.88), location: 1.00)
//                        ],
//                        startPoint: UnitPoint(x: 0, y: 0),
//                        endPoint: UnitPoint(x: 1.02, y: 0.65)
//                    )
//                }
//                .edgesIgnoringSafeArea(.all)
//                
//                VStack {
//                    // 상단 날짜 변경 영역
//                    HStack {
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            Image(systemName: "chevron.left")
//                                .font(.system(size: 20))
//                                .foregroundColor(.button)
//                        }
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            withAnimation {
//                                isDatePickerVisible.toggle()
//                            }
//                        }) {
//                            Text("\(String(selectedYear)) \(monthFormatter(selectedMonth))")
//                                .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 32))
//                                .foregroundColor(.black)
//                        }
//                        
//                        Spacer()
//                    }
//                    .padding(.horizontal, 30)
//                
//
//                    // 리스트뷰
//                    if journalCards.isEmpty {
//                        Spacer()
//                        Text("텅 ~ 이 달의 Thancho를 채워보아요")
//                            .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 24))
//                            .foregroundColor(.black)
//                        Spacer()
//                    } else {
//                        ScrollView {
//                            VStack(spacing: 12) {
//                                ForEach(journalCards.indices, id: \.self) { index in
//                                    ZStack(alignment: .topTrailing) {
//                                        VStack(alignment: .leading, spacing: 4) {
//                                            // 날짜
//                                            Text(journalCards[index].date)
//                                                .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 24))
//                                                .foregroundColor(.black)
//                                                .frame(maxWidth: .infinity, alignment: .topLeading)
//
//                                            // 내용
//                                            Text(journalCards[index].content)
//                                                .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 22))
//                                                .foregroundColor(.black)
//                                                .frame(maxWidth: .infinity, alignment: .topLeading)
//                                                .padding(.bottom,8)
//                                    
//
//                                            // 이미지 프리뷰
//                                            if !journalCards[index].images.isEmpty {
//                                                HStack(spacing: 8) {
//                                                    ForEach(Array(journalCards[index].images.prefix(3).enumerated()), id: \.offset) { _, image in
//                                                        Image(uiImage: image)
//                                                            .resizable()
//                                                            .frame(width: 30, height: 30)
//                                                            .cornerRadius(4)
//                                                            .onTapGesture {
//                                                                selectedImageForViewer = image
//                                                                showImageViewer = true
//                                                            }
//                                                    }
//                                                    
//                                                    
//                                                    if journalCards[index].images.count > 3 {
//                                                        ZStack {
//                                                            Color.black.opacity(0.5)
//                                                                .frame(width: 30, height: 30)
//                                                                .cornerRadius(4)
//                                                            Text("+\(journalCards[index].images.count - 3)")
//                                                                .foregroundColor(.white)
//                                                                .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 20))
//                                                        }
//                                                    }
//                                                }
//                                                .padding(.top, 1)
//                                            
//                                            }
//                                        }
//                                        .padding(.horizontal, 24)
//                                        .padding(.vertical, 18)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2))
//                                        .cornerRadius(12)
//
//                                        // 우측 상단 메뉴 버튼
//                                        Button(action: {
//                                            withAnimation {
//                                                expandedMenuId = (expandedMenuId == journalCards[index].id) ? nil : journalCards[index].id
//                                            }
//                                        }) {
//                                            Image(systemName: "ellipsis")
//                                                .padding(20)
//                                                .foregroundColor(.black)
//                                        }
//
//                                        // 메뉴 (수정하기/삭제하기)
//                                        if expandedMenuId == journalCards[index].id {
//                                            VStack(alignment: .leading) {
//                                                Button(action: {
//                                                    print("수정하기 버튼 클릭")
//                                                }) {
//                                                    Text("수정하기")
//                                                }
//                                                .padding()
//                                                
//                                                Button(role: .destructive, action: {
//                                                    journalCards.remove(at: index)
//                                                }) {
//                                                    Text("삭제하기")
//                                                }
//                                                .padding()
//                                            }
//                                            .background(Color.white)
//                                            .cornerRadius(10)
//                                            .shadow(radius: 5)
//                                        }
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 20)
//                        }
//                        .onTapGesture {
//                            expandedMenuId = nil
//                        }
//                    }
//                }
//                if isDatePickerVisible {
//                                   VStack(spacing: 16) {
//                                       Spacer()
//               
//                                       VStack {
//                                           Picker("년도 선택", selection: $selectedYear) {
//                                               ForEach(2020...2030, id: \.self) { year in
//                                                   Text("\(String(year))").tag(year)
//                                               }
//                                           }
//                                           .pickerStyle(WheelPickerStyle())
//                                           .labelsHidden()
//               
//                                           Picker("월 선택", selection: $selectedMonth) {
//                                               ForEach(1...12, id: \.self) { month in
//                                                   Text(monthFormatter(month)).tag(month)
//                                               }
//                                           }
//                                           .pickerStyle(WheelPickerStyle())
//                                           .labelsHidden()
//                                       }
//                                       .background(Color.white)
//                                       .cornerRadius(16)
//                                       .shadow(radius: 10)
//                                       .padding()
//               
//                                       Button(action: {
//                                           withAnimation {
//                                               isDatePickerVisible.toggle()
//                                           }
//                                       }) {
//                                           Text("확인")
//                                               .fontWeight(.bold)
//                                               .foregroundColor(.white)
//                                               .padding()
//                                               .background(Color.blue)
//                                               .cornerRadius(10)
//                                               .padding(.horizontal, 20)
//                                       }
//                                   }
//                                   .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
//                                   .transition(.opacity)
//                               }
//                           }
//            .sheet(isPresented: $showImageViewer) {
//                if let selectedImage = selectedImageForViewer {
//                    ZStack {
//                        Color.black.ignoresSafeArea()
//                        Image(uiImage: selectedImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        Button(action: { showImageViewer = false }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(.white)
//                                .font(.largeTitle)
//                                .padding()
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func monthFormatter(_ month: Int) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM"
//        return formatter.monthSymbols[month - 1]
//    }
//}
//
//struct JournalCardExampleView_Previews: PreviewProvider {
//    static var previews: some View {
//        JournalCardExampleView()
//    }
//}
//
//#Preview {
//    JournalCardExampleView()
//}
import SwiftUI
import SwiftData

struct JournalCardExampleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\Journal.date, order: .reverse)]) var journals: [Journal]

    @State private var showImageViewer = false
    @State private var selectedImageForViewer: UIImage? = nil
    @State private var expandedMenuId: PersistentIdentifier? = nil
    @State private var navigateToJournal: Journal? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                contentView
            }
            .sheet(isPresented: $showImageViewer) {
                if let selected = selectedImageForViewer {
                    imageViewer(for: selected)
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { navigateToJournal != nil },
                set: { isActive in if !isActive { navigateToJournal = nil } }
            )) {
                if let journal = navigateToJournal {
                    JournalEntryView(journal: journal)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }

    @ViewBuilder
    var backgroundView: some View {
        LinearGradient(
            colors: [Color.white, Color(red: 0.88, green: 0.88, blue: 0.88)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }

    @ViewBuilder
    var contentView: some View {
        VStack(spacing: 0) {
            topBar
            journalList
        }
    }

    @ViewBuilder
    var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            Spacer()
            Text("모아보기")
                .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 28))
                .foregroundColor(.black)
            Spacer().frame(width: 20)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }

    @ViewBuilder
    var journalList: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(journals) { journal in
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            navigateToJournal = journal
                        }) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(formattedDate(journal.date))
                                    .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 22))
                                    .foregroundColor(.black)

                                Text(journal.content)
                                    .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 20))
                                    .foregroundColor(.black)

                                if !journal.imageDataArray.isEmpty {
                                    HStack(spacing: 6) {
                                        ForEach(Array(journal.imageDataArray.prefix(3).enumerated()), id: \.offset) { index, data in
                                            if let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .cornerRadius(4)
                                                    .onTapGesture {
                                                        selectedImageForViewer = uiImage
                                                        showImageViewer = true
                                                    }
                                            }
                                        }
                                        if journal.imageDataArray.count > 3 {
                                            let extra = journal.imageDataArray.count - 3
                                            Text("+​\(extra)")
                                                .frame(width: 30, height: 30)
                                                .background(Color.gray)
                                                .cornerRadius(4)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 0.9, green: 0.94, blue: 1.0))
                            .cornerRadius(12)
                        }

                        Button(action: {
                            withAnimation {
                                expandedMenuId = (expandedMenuId == journal.persistentModelID) ? nil : journal.persistentModelID
                            }
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .padding(20)
                        }

                        if expandedMenuId == journal.persistentModelID {
                            VStack(alignment: .leading, spacing: 0) {
                                Button("삭제하기", role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(journal)
                                        try? modelContext.save()
                                        expandedMenuId = nil
                                    }
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.trailing, 12)
                            .padding(.top, 44)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            expandedMenuId = nil
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    @ViewBuilder
    func imageViewer(for image: UIImage) -> some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
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

#Preview {
    JournalCardExampleView()
}

////////////////
////////////////  JournalCardExampleView
////////////////  Thancho
////////////////
//////////////////  Created by 박지희 on 4/16/25.
import SwiftUI
import SwiftData

struct JournalCardExampleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\Journal.date, order: .forward)]) var journals: [Journal]

    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var isDatePickerVisible = false
    @State private var showImageViewer = false
    @State private var selectedJournalImages: [UIImage] = []
    @State private var selectedImageIndex: Int = 0
    @State private var navigateToJournal: Journal? = nil
    @State private var isJournalEntryActive: Bool = false
    @State private var forceWritingMode: Bool = false

    @State private var journalToDelete: Journal? = nil
    @State private var showDeleteAlert: Bool = false

    var filteredJournals: [Journal] {
        journals.filter {
            let components = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return components.year == selectedYear && components.month == selectedMonth
        }
    }

    var headerTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return "\(selectedYear) \(formatter.monthSymbols[selectedMonth - 1])"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, Color(red: 0.88, green: 0.88, blue: 0.88)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2) // 아이콘 크기
                                .foregroundColor(.black)
    
                            
                        }
                        Spacer()
                        Button(action: { withAnimation { isDatePickerVisible.toggle() } }) {
                            HStack(spacing: 6) {
                                Image("Calendar")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .padding(.top, 4)
                                Text(headerTitle)
                                    .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 28))
                                    .foregroundColor(Color("sBlue"))
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 16)

                    if filteredJournals.isEmpty {
                        Spacer()
                        Text("텅 ~ 이 달의 Thancho를 채워보아요")
                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 24))
                            .foregroundColor(.black)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(filteredJournals) { journal in
                                    JournalCard(journal: journal)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
                .padding(.top, 32)

                if isDatePickerVisible {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                            .onTapGesture {
                                withAnimation { isDatePickerVisible = false }
                            }

                        VStack(spacing: 16) {
                            HStack {
                                Picker("년도 선택", selection: $selectedYear) {
                                    ForEach(2020...2030, id: \.self) { year in
                                        Text(String(year)).tag(year)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 120)
                                .clipped()

                                Picker("월 선택", selection: $selectedMonth) {
                                    ForEach(1...12, id: \.self) { month in
                                        Text(monthFormatter(month)).tag(month)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 120)
                                .clipped()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 6)
                        }
                    }
                    .onChange(of: selectedYear) { _ in
                        withAnimation { isDatePickerVisible = false }
                    }
                    .onChange(of: selectedMonth) { _ in
                        withAnimation { isDatePickerVisible = false }
                    }
                }
            }
            .navigationDestination(isPresented: $isJournalEntryActive) {
                if let journal = navigateToJournal {
                    JournalEntryView(journal: journal, forceWritingMode: forceWritingMode)
                }
            }
            .sheet(isPresented: $showImageViewer) {
                TabView(selection: $selectedImageIndex) {
                    ForEach(selectedJournalImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Color.white.ignoresSafeArea()
                            Image(uiImage: selectedJournalImages[index])
                                .resizable()
                                .scaledToFit()
                            Button(action: { showImageViewer = false }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .padding()
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                Button("삭제", role: .destructive) {
                    if let journal = journalToDelete,
                       let index = journals.firstIndex(where: { $0.id == journal.id }) {
                        modelContext.delete(journals[index])
                        try? modelContext.save()
                    }
                }
                Button("취소", role: .cancel) {
                    journalToDelete = nil
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    func monthFormatter(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.monthSymbols[month - 1]
    }

    @ViewBuilder
    private func JournalCard(journal: Journal) -> some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                navigateToJournal = journal
                forceWritingMode = false
                isJournalEntryActive = true
            }) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(formattedDate(journal.date))
                        .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 22))
                        .foregroundColor(.black)

                    Text(journal.content)
                        .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 21))
                        .foregroundColor(.black)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)

                    if !journal.imageDataArray.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(Array(journal.imageDataArray.prefix(3).enumerated()), id: \.offset) { index, data in
                                if let image = UIImage(data: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 36, height: 36)
                                        .cornerRadius(6)
                                        .onTapGesture {
                                            selectedJournalImages = journal.imageDataArray.compactMap { UIImage(data: $0) }
                                            selectedImageIndex = index
                                            showImageViewer = true
                                        }
                                }
                            }
                            if journal.imageDataArray.count > 3,
                               let image = UIImage(data: journal.imageDataArray[3]) {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 36, height: 36)
                                        .cornerRadius(6)
                                        .overlay(Color.black.opacity(0.4).cornerRadius(6))
                                        .onTapGesture {
                                            selectedJournalImages = journal.imageDataArray.compactMap { UIImage(data: $0) }
                                            selectedImageIndex = 3
                                            showImageViewer = true
                                        }

                                    Text("+\(journal.imageDataArray.count - 3)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2))
                .cornerRadius(14)
            }

            Menu {
                Button("수정하기") {
                    navigateToJournal = journal
                    forceWritingMode = true
                    isJournalEntryActive = true
                }
                Button("삭제하기", role: .destructive) {
                    journalToDelete = journal
                    showDeleteAlert = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
                    .padding(20)
            }
        }
    }
}

//////////
//////////  JournalCardExampleView
//////////  Thancho2
//////////
////////////  Created by 박지희 on 4/16/25.

//import SwiftUI
//import SwiftData
//
//import Foundation // ➜ SwiftData가 가지고 있는 Data Model 과던 부모 코드를 제거하지 않으면 두 번 등록 되는 경우가 있어요.
//
//struct JournalCardExampleView: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) private var modelContext
//
//    @Query(sort: [SortDescriptor(\Journal.date, order: .forward)]) var journals: [Journal]
//
//    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
//    @State private var isDatePickerVisible = false
//    @State private var showImageViewer = false
//    @State private var selectedImageForViewer: UIImage? = nil
//    @State private var navigateToJournal: Journal? = nil
//    @State private var isJournalEntryActive: Bool = false
//
//    var filteredJournals: [Journal] {
//        journals.filter {
//            let components = Calendar.current.dateComponents([.year, .month], from: $0.date)
//            return components.year == selectedYear && components.month == selectedMonth
//        }
//    }
//
//    var headerTitle: String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US")
//        return "\(selectedYear) \(formatter.monthSymbols[selectedMonth - 1])"
//    }
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                LinearGradient(colors: [.white, Color(red: 0.88, green: 0.88, blue: 0.88)],
//                               startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//                    HStack {
//                        Button(action: { dismiss() }) {
//                            Image(systemName: "chevron.left")
//                                .font(.system(size: 20))
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                        Button(action: { withAnimation { isDatePickerVisible.toggle() } }) {
//                            Text(headerTitle)
//                                .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 28))
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.bottom, 16)
//
//                    if filteredJournals.isEmpty {
//                        Spacer()
//                        Text("텅 ~ 이 달의 Thancho를 채워보아요")
//                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 24))
//                            .foregroundColor(.black)
//                        Spacer()
//                    } else {
//                        ScrollView {
//                            VStack(spacing: 12) {
//                                ForEach(filteredJournals) { journal in
//                                    ZStack(alignment: .topTrailing) {
//                                        Button(action: {
//                                            navigateToJournal = journal
//                                            isJournalEntryActive = true
//                                        }) {
//                                            VStack(alignment: .leading, spacing: 6) {
//                                                Text(formattedDate(journal.date))
//                                                    .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 22))
//                                                    .foregroundColor(.black)
//
//                                                Text(journal.content)
//                                                    .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 20))
//                                                    .foregroundColor(.black)
//                                                    .lineLimit(3)
//
//                                                if !journal.imageDataArray.isEmpty {
//                                                    HStack(spacing: 6) {
//                                                        ForEach(Array(journal.imageDataArray.prefix(3).enumerated()), id: \.offset) { _, data in
//                                                            if let image = UIImage(data: data) {
//                                                                Image(uiImage: image)
//                                                                    .resizable()
//                                                                    .frame(width: 36, height: 36)
//                                                                    .cornerRadius(6)
//                                                            }
//                                                        }
//                                                        if journal.imageDataArray.count > 3 {
//                                                            let lastData = journal.imageDataArray[3]
//                                                            if let fourthImage = UIImage(data: lastData) {
//                                                                ZStack {
//                                                                    Image(uiImage: fourthImage)
//                                                                        .resizable()
//                                                                        .frame(width: 36, height: 36)
//                                                                        .cornerRadius(6)
//                                                                        .overlay(Color.black.opacity(0.4).cornerRadius(6))
//
//                                                                    Text("+\(journal.imageDataArray.count - 3)")
//                                                                        .foregroundColor(.white)
//                                                                        .font(.system(size: 14))
//                                                                }
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                            .padding(18)
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                            .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2))
//                                            .cornerRadius(14)
//                                        }
//
//                                        Menu {
//                                            Button("수정하기") {
//                                                navigateToJournal = journal
//                                                isJournalEntryActive = true
//                                            }
//                                            Button("삭제하기", role: .destructive) {
//                                                if let index = journals.firstIndex(where: { $0.id == journal.id }) {
//                                                    modelContext.delete(journals[index])
//                                                }
//                                            }
//                                        } label: {
//                                            Image(systemName: "ellipsis")
//                                                .foregroundColor(.black)
//                                                .padding(20)
//                                        }
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 20)
//                        }
//                    }
//                }
//                .padding(.top, 32)
//
//                if isDatePickerVisible {
//                    Color.black.opacity(0.4).ignoresSafeArea()
//                    VStack(spacing: 16) {
//                        Spacer()
//                        HStack {
//                            Picker("년도 선택", selection: $selectedYear) {
//                                ForEach(2020...2030, id: \.self) { year in
//                                    Text("\(year)").tag(year)
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 120)
//                            .clipped()
//
//                            Picker("월 선택", selection: $selectedMonth) {
//                                ForEach(1...12, id: \.self) { month in
//                                    Text(monthFormatter(month)).tag(month)
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 120)
//                            .clipped()
//                        }
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .shadow(radius: 6)
//
//                        Button("확인") {
//                            withAnimation {
//                                isDatePickerVisible.toggle()
//                            }
//                        }
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color(red: 0.502, green: 0.686, blue: 0.843))
//                        .cornerRadius(10)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .contentShape(Rectangle())
//                    .background(Color.clear)
//                }
//            }
//            .navigationDestination(isPresented: $isJournalEntryActive) {
//                if let journal = navigateToJournal {
//                    JournalEntryView(journal: journal)
//                }
//            }
//            .sheet(isPresented: $showImageViewer) {
//                if let image = selectedImageForViewer {
//                    ZStack(alignment: .topTrailing) {
//                        Color.black.ignoresSafeArea()
//                        Image(uiImage: image)
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
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy. MM. dd EEEE"
//        formatter.locale = Locale(identifier: "ko_KR")
//        return formatter.string(from: date)
//    }
//
//    private func monthFormatter(_ month: Int) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US")
//        return formatter.monthSymbols[month - 1]
//    }
//}
//
//import SwiftUI
//import SwiftData
//
//struct JournalCardExampleView: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) private var modelContext
//
//    @Query(sort: [SortDescriptor(\Journal.date, order: .forward)]) var journals: [Journal]
//
//    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
//    @State private var isDatePickerVisible = false
//    @State private var showImageViewer = false
//    @State private var selectedImageForViewer: UIImage? = nil
//    @State private var navigateToJournal: Journal? = nil
//    @State private var isJournalEntryActive: Bool = false
//
//    var filteredJournals: [Journal] {
//        journals.filter {
//            let components = Calendar.current.dateComponents([.year, .month], from: $0.date)
//            return components.year == selectedYear && components.month == selectedMonth
//        }
//    }
//
//    var headerTitle: String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US")
//        return "\(selectedYear) \(formatter.monthSymbols[selectedMonth - 1])"
//    }
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                LinearGradient(colors: [.white, Color(red: 0.88, green: 0.88, blue: 0.88)],
//                               startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//                    HStack {
//                        Button(action: { dismiss() }) {
//                            Image(systemName: "chevron.left")
//                                .font(.system(size: 20))
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                        Button(action: { withAnimation { isDatePickerVisible.toggle() } }) {
//                            Text(headerTitle)
//                                .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 28))
//                                .foregroundColor(.black)
//                        }
//                        Spacer()
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.bottom, 16)
//
//                    if filteredJournals.isEmpty {
//                        Spacer()
//                        Text("텅 ~ 이 달의 Thancho를 채워보아요")
//                            .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 24))
//                            .foregroundColor(.black)
//                        Spacer()
//                    } else {
//                        ScrollView {
//                            VStack(spacing: 12) {
//                                ForEach(filteredJournals) { journal in
//                                    ZStack(alignment: .topTrailing) {
//                                        Button(action: {
//                                            navigateToJournal = journal
//                                            isJournalEntryActive = true
//                                        }) {
//                                            VStack(alignment: .leading, spacing: 6) {
//                                                Text(formattedDate(journal.date))
//                                                    .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 22))
//                                                    .foregroundColor(.black)
//
//                                                Text(journal.content)
//                                                    .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 20))
//                                                    .foregroundColor(.black)
//                                                    .lineLimit(3)
//
//                                                if !journal.imageDataArray.isEmpty {
//                                                    HStack(spacing: 6) {
//                                                        ForEach(Array(journal.imageDataArray.prefix(3).enumerated()), id: \ .offset) { _, data in
//                                                            if let image = UIImage(data: data) {
//                                                                Image(uiImage: image)
//                                                                    .resizable()
//                                                                    .frame(width: 36, height: 36)
//                                                                    .cornerRadius(6)
//                                                            }
//                                                        }
//                                                        if journal.imageDataArray.count > 3 {
//                                                            let lastData = journal.imageDataArray[3]
//                                                            if let fourthImage = UIImage(data: lastData) {
//                                                                Button(action: {
//                                                                    selectedImageForViewer = fourthImage
//                                                                    showImageViewer = true
//                                                                }) {
//                                                                    ZStack {
//                                                                        Image(uiImage: fourthImage)
//                                                                            .resizable()
//                                                                            .frame(width: 36, height: 36)
//                                                                            .cornerRadius(6)
//                                                                            .overlay(Color.black.opacity(0.4).cornerRadius(6))
//
//                                                                        Text("+\(journal.imageDataArray.count - 3)")
//                                                                            .foregroundColor(.white)
//                                                                            .font(.system(size: 14))
//                                                                    }
//                                                                }
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                            .padding(18)
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                            .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2))
//                                            .cornerRadius(14)
//                                        }
//
//                                        Menu {
//                                            Button("수정하기") {
//                                                navigateToJournal = journal
//                                                isJournalEntryActive = true
//                                            }
//                                            Button("삭제하기", role: .destructive) {
//                                                if let index = journals.firstIndex(where: { $0.id == journal.id }) {
//                                                    modelContext.delete(journals[index])
//                                                }
//                                            }
//                                        } label: {
//                                            Image(systemName: "ellipsis")
//                                                .foregroundColor(.black)
//                                                .padding(20)
//                                        }
//                                    }
//                                }
//                            }
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 20)
//                        }
//                    }
//                }
//                .padding(.top, 32)
//
//                if isDatePickerVisible {
//                    Color.black.opacity(0.4).ignoresSafeArea()
//                    VStack(spacing: 16) {
//                        Spacer()
//                        HStack {
//                            Picker("년도 선택", selection: $selectedYear) {
//                                ForEach(2020...2030, id: \.self) { year in
//                                    Text("\(year)").tag(year)
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 120)
//                            .clipped()
//
//                            Picker("월 선택", selection: $selectedMonth) {
//                                ForEach(1...12, id: \.self) { month in
//                                    Text(monthFormatter(month)).tag(month)
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 120)
//                            .clipped()
//                        }
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .shadow(radius: 6)
//
//                        Button("확인") {
//                            withAnimation {
//                                isDatePickerVisible.toggle()
//                            }
//                        }
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color(red: 0.502, green: 0.686, blue: 0.843))
//                        .cornerRadius(10)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .contentShape(Rectangle())
//                    .background(Color.clear)
//                }
//            }
//            .navigationDestination(isPresented: $isJournalEntryActive) {
//                if let journal = navigateToJournal {
//                    JournalEntryView(journal: journal)
//                }
//            }
//            .sheet(isPresented: $showImageViewer) {
//                if let image = selectedImageForViewer {
//                    ZStack(alignment: .topTrailing) {
//                        Color.black.ignoresSafeArea()
//                        Image(uiImage: image)
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
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy. MM. dd EEEE"
//        formatter.locale = Locale(identifier: "ko_KR")
//        return formatter.string(from: date)
//    }
//
//    private func monthFormatter(_ month: Int) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US")
//        return formatter.monthSymbols[month - 1]
//    }
//}




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
    @State private var selectedImageForViewer: UIImage? = nil
    @State private var navigateToJournal: Journal? = nil
    @State private var isJournalEntryActive: Bool = false
    @State private var forceWritingMode: Bool = false

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
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Button(action: { withAnimation { isDatePickerVisible.toggle() } }) {
                            Text(headerTitle)
                                .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 28))
                                .foregroundColor(.black)
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
                                                    .font(.custom("Nanum YuNiDdingDdangDdingDdang", size: 20))
                                                    .foregroundColor(.black)
                                                    .lineLimit(3)

                                                if !journal.imageDataArray.isEmpty {
                                                    HStack(spacing: 6) {
                                                        ForEach(Array(journal.imageDataArray.prefix(3).enumerated()), id: \ .offset) { index, data in
                                                            if let image = UIImage(data: data) {
                                                                Image(uiImage: image)
                                                                    .resizable()
                                                                    .frame(width: 36, height: 36)
                                                                    .cornerRadius(6)
                                                                    .onTapGesture {
                                                                        selectedImageForViewer = image
                                                                        showImageViewer = true
                                                                    }
                                                            }
                                                        }
                                                        if journal.imageDataArray.count > 3 {
                                                            let lastData = journal.imageDataArray[3]
                                                            if let fourthImage = UIImage(data: lastData) {
                                                                Button(action: {
                                                                    selectedImageForViewer = fourthImage
                                                                    showImageViewer = true
                                                                }) {
                                                                    ZStack {
                                                                        Image(uiImage: fourthImage)
                                                                            .resizable()
                                                                            .frame(width: 36, height: 36)
                                                                            .cornerRadius(6)
                                                                            .overlay(Color.black.opacity(0.4).cornerRadius(6))

                                                                        Text("+\(journal.imageDataArray.count - 3)")
                                                                            .foregroundColor(.white)
                                                                            .font(.system(size: 14))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(18)
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
                                                if let index = journals.firstIndex(where: { $0.id == journal.id }) {
                                                    modelContext.delete(journals[index])
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.black)
                                                .padding(20)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
                .padding(.top, 32)

                if isDatePickerVisible {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    VStack(spacing: 16) {
                        Spacer()
                        HStack {
                            Picker("년도 선택", selection: $selectedYear) {
                                ForEach(2020...2030, id: \.self) { year in
                                    Text("\(year)").tag(year)
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
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 6)

                        Button("확인") {
                            withAnimation {
                                isDatePickerVisible.toggle()
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.502, green: 0.686, blue: 0.843))
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .background(Color.clear)
                }
            }
            .navigationDestination(isPresented: $isJournalEntryActive) {
                if let journal = navigateToJournal {
                    JournalEntryView(journal: journal, forceWritingMode: forceWritingMode)
                }
            }
            .sheet(isPresented: $showImageViewer) {
                if let image = selectedImageForViewer {
                    ZStack(alignment: .topTrailing) {
                        Color.black.ignoresSafeArea()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Button(action: { showImageViewer = false }) {
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

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    private func monthFormatter(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.monthSymbols[month - 1]
    }
}

//////////  JournalEntryView.swift
//////////  Thancho2
//////////
//////////  Created by 박지희 on 4/15/25.
import SwiftUI
import PhotosUI
import SwiftData

enum ModeType: String {
    case writing = "Writing"
    case saving = "Saving"
}

struct JournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var navigateToMain = false

    @State private var mode: ModeType = .writing
    @State private var currentDate: Date = Date()
    @State private var entryText: String = ""
    @State private var showCalendar: Bool = false
    @State private var showMenu: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showSavedAlert: Bool = false

    @State private var selectedImages: [UIImage] = []
    @State private var showImageViewer: Bool = false
    @State private var selectedImageIndex: Int = 0
    @State private var imageSelections: [PhotosPickerItem] = []

    @State private var dateButtonFrame: CGRect = .zero
    @FocusState private var isTextEditorFocused: Bool

    var editingJournal: Journal?

    init(journal: Journal? = nil, forceWritingMode: Bool = false) {
        self.editingJournal = journal
        if let journal = journal {
            _mode = State(initialValue: forceWritingMode ? .writing : .saving)
            _currentDate = State(initialValue: journal.date)
            _entryText = State(initialValue: journal.content)
            _selectedImages = State(initialValue: journal.imageDataArray.compactMap { UIImage(data: $0) })
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: currentDate)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.white.opacity(0.001) // invisible background for tap gesture
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTextEditorFocused = false
                    }

                VStack(spacing: 0) {
                    topBar
                    dateSelector
                    entryTextEditor
                    if mode == .writing { imageButtons }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .coordinateSpace(name: "JournalEntryViewSpace")

                if showCalendar { calendarBackground }
                if showCalendar { calendarView(proxy: proxy) }
                if showMenu { menuView }
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let journal = editingJournal {
                        modelContext.delete(journal)
                        try? modelContext.save()
                    }
                    entryText = ""
                    selectedImages = []
                    mode = .writing
                    navigateToMain = true
                }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showImageViewer) {
                TabView(selection: $selectedImageIndex) {
                    ForEach(selectedImages.indices, id: \.self) { i in
                        ZStack(alignment: .topTrailing) {
                            Color.black.ignoresSafeArea()
                            Image(uiImage: selectedImages[i])
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
                .tabViewStyle(PageTabViewStyle())
            }
            .alert("글이 저장되었습니다!", isPresented: $showSavedAlert) {
                Button("확인") {
                    navigateToMain = true
                }
            }
            .background(
                NavigationLink(destination: MainView(), isActive: $navigateToMain) {
                    EmptyView()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                    .padding(.leading, 12)
            }
            Spacer()
            Button(action: saveOrToggleMenu) {
                Image(systemName: mode == .writing ? "checkmark" : "ellipsis")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.top, 12)
    }

    private var dateSelector: some View {
        VStack(spacing: 4) {
            Button(action: {
                if mode == .writing {
                    withAnimation { showCalendar.toggle() }
                }
            }) {
                HStack(spacing: 6) {
                    Image("Calendar")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(.top, 8)
                    Text(formattedDate)
                        .font(.custom("NanumYuniDdingDdangDdingDdang", size: 28))
                        .foregroundColor(.black)
                }
            }
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        self.dateButtonFrame = geo.frame(in: .named("JournalEntryViewSpace"))
                    }
                }
            )
        }
        .padding(.top, 16)
    }

    private var entryTextEditor: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TextEditor(text: $entryText)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, selectedImages.isEmpty ? 20 : 0)
                    .scrollContentBackground(.hidden)
                    .font(.custom("NanumYuniDdingDdangDdingDdang", size: 24))
                    .background(Color.clear)
                    .frame(maxHeight: .infinity)
                    .focused($isTextEditorFocused)
                    .disabled(mode == .saving)

                if !selectedImages.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(Array(selectedImages.prefix(3).enumerated()), id: \.offset) { index, image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .cornerRadius(6)
                                    .onTapGesture {
                                        selectedImageIndex = index
                                        showImageViewer = true
                                    }

                                if mode == .writing {
                                    Button(action: {
                                        selectedImages.remove(at: index)
                                    }) {
                                        Image("Cancel")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                    }
                                    .padding(4)
                                }
                            }
                        }
                        if selectedImages.count > 3 {
                            let index = 3
                            let image = selectedImages[index]
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .cornerRadius(6)
                                    .overlay(Color.black.opacity(0.4).cornerRadius(6))
                                    .onTapGesture {
                                        selectedImageIndex = index
                                        showImageViewer = true
                                    }

                                Text("+\(selectedImages.count - 3)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 18)
                }
            }
            .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            if entryText.isEmpty {
                Text("마음에 울린 감사의 메아리를 적어보아요")
                    .font(.custom("NanumYuniDdingDdangDdingDdang", size: 24))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 28)
                    .padding(.top, 28)
            }
        }
        .padding(.top, 20)
        .frame(height: 540)
    }

    private var imageButtons: some View {
        HStack(spacing: 9) {
            Button(action: {}) {
                Image("Camera")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            PhotosPicker(selection: $imageSelections, maxSelectionCount: 10, matching: .images) {
                Image("Media")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .onChange(of: imageSelections) { newItems in
                for item in newItems {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImages.append(uiImage)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 30)
        .padding(.bottom, 30)
    }

    private var calendarBackground: some View {
        Color.black.opacity(0.001)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation { showCalendar = false }
            }
    }

    private func calendarView(proxy: GeometryProxy) -> some View {
        VStack {
            DatePicker("", selection: $currentDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(.pBlue)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 6)
                .onChange(of: currentDate) { _ in
                    withAnimation { showCalendar = false }
                }
        }
        .frame(width: 320)
        .position(
            x: proxy.size.width / 2,
            y: dateButtonFrame.origin.y + dateButtonFrame.size.height + 176
        )
        .transition(.opacity)
    }

    private var menuView: some View {
        VStack {
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    Button("수정하기") {
                        mode = .writing
                        withAnimation { showMenu = false }
                    }
                    .padding()
                    .foregroundColor(.black)
                    Divider()
                    Button("삭제하기") {
                        withAnimation { showMenu = false }
                        showDeleteAlert = true
                    }
                    .padding()
                    .foregroundColor(.red)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(width: 120)
                .padding(.trailing, 12)
                .padding(.top, 44)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            withAnimation { showMenu = false }
        }
    }

    private func saveOrToggleMenu() {
        if mode == .writing {
            if let journal = editingJournal {
                journal.date = currentDate
                journal.content = entryText
                journal.imageDataArray = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
            } else {
                let newJournal = Journal(
                    date: currentDate,
                    content: entryText,
                    imageDataArray: selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                )
                modelContext.insert(newJournal)
            }
            do {
                try modelContext.save()
                mode = .saving
                showSavedAlert = true
            } catch {
                print("❌ Save failed: \(error.localizedDescription)")
            }
        } else {
            withAnimation { showMenu.toggle() }
        }
    }
}

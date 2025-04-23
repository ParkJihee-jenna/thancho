//////////  JournalEntryView.swift
//////////  Thancho2
//////////
//////////  Created by 박지희 on 4/15/25.

import SwiftUI
import PhotosUI       // 사진 선택 기능을 위한 라이브러리
import SwiftData       // 모델 저장 기능을 위한 라이브러리
import Vision          // OCR (이미지 속 글자 인식)을 위한 프레임워크

// 작성 상태를 구분하기 위한 열거형
enum ModeType: String {
    case writing = "Writing"  // 작성 중
    case saving = "Saving"    // 저장된 상태
}

// 일기(Thancho)를 작성하거나 수정하는 화면을 보여주는 구조체.
struct JournalEntryView: View {
    @Environment(\.dismiss) var dismiss  // 뷰를 닫는 기능
    @Environment(\.modelContext) private var modelContext  // SwiftData의 저장소 연결
    
    @State private var navigateToMain = false  // 저장 후 메인화면으로 돌아가는지 여부
    
    // 작성 또는 수정 모드 설정
    @State private var mode: ModeType = .writing
    // 현재 선택된 날짜
    @State private var currentDate: Date = Date()
    // 사용자가 작성하는 텍스트 내용
    @State private var entryText: String = ""
    
    // 캘린더, 메뉴, 삭제 경고창 등 보이기 상태들
    @State private var showCalendar: Bool = false
    @State private var showMenu: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showSavedAlert: Bool = false
    @State private var showSnow: Bool = true  // 첫 진입 시 눈 애니메이션 보여줄지 여부
    
    // 선택된 이미지들 저장
    @State private var selectedImages: [UIImage] = []
    // 이미지 전체 보기 모드
    @State private var showImageViewer: Bool = false
    @State private var selectedImageIndex: Int = 0
    @State private var imageSelections: [PhotosPickerItem] = []  // 사진첩에서 선택한 항목들
    
    // 카메라 띄울지 여부
    @State private var showCamera = false
    
    // 날짜 선택 버튼 위치 계산용
    @State private var dateButtonFrame: CGRect = .zero
    
    // 새 알림 상태 추가
    @State private var showEmptyTextAlert: Bool = false

    
    // 텍스트 에디터 포커스 상태 관리
    @FocusState private var isTextEditorFocused: Bool
    
    // 수정 중인 일기 객체 (없으면 새로 쓰는 것)
    var editingJournal: Journal?
    
    // 뷰가 생성될 때 수정모드인지, 새로 작성인지 판별
    init(journal: Journal? = nil, forceWritingMode: Bool = false) {
        self.editingJournal = journal
        if let journal = journal {
            // 수정 모드일 경우 기존 데이터 반영
            _mode = State(initialValue: forceWritingMode ? .writing : .saving)
            _currentDate = State(initialValue: journal.date)
            _entryText = State(initialValue: journal.content)
            _selectedImages = State(initialValue: journal.imageDataArray.compactMap { UIImage(data: $0) })
        }
    }
    // 날짜를 포맷팅해서 문자열로 변환하는 변수 (예: 2025. 04. 23 수요일)
    var formattedDate: String {
        let formatter = DateFormatter()                   // 날짜 포맷터 객체 생성
        formatter.dateFormat = "yyyy. MM. dd EEEE"        // 연. 월. 일 요일 형식 지정
        formatter.locale = Locale(identifier: "ko_KR")    // 한국어로 요일이 보이도록 설정
        return formatter.string(from: currentDate)        // currentDate를 문자열로 변환해서 반환
    }
    
    var body: some View {
        GeometryReader { proxy in                         // 화면의 크기를 측정해서 활용할 수 있게 해줌
            ZStack(alignment: .topLeading) {              // 겹쳐서 뷰를 배치하는 컨테이너, 좌측 상단 정렬
                
                // 배경 색을 흰색으로 설정하고, 화면 전체에 적용
                Color.white.ignoresSafeArea()
                    .onTapGesture { isTextEditorFocused = false } // 화면 아무 곳이나 탭하면 키보드 내려감
                
                // VStack: 화면의 주요 내용을 위에서 아래로 정렬
                VStack(spacing: 0) {
                    topBar              // 상단 바 (뒤로가기, 저장 버튼 등)
                    dateSelector        // 날짜 선택 뷰
                    entryTextEditor     // 텍스트 작성창 (일기 내용)
                    if mode == .writing { imageButtons }  // 작성 모드일 때만 이미지 추가 버튼 표시
                    Spacer()            // 아래에 빈 공간을 만들어서 내용이 위로 밀리지 않도록 함
                }
                .padding(.horizontal, 24)   // 좌우 여백을 24포인트로 설정
                .coordinateSpace(name: "JournalEntryViewSpace") // 커스텀 좌표 공간 이름 지정
                .zIndex(0)                 // ZStack 안에서 기본 우선순위 (가장 뒤쪽)
                
                // 달력 보기 모드일 때만 표시
                if showCalendar { calendarBackground }    // 달력 배경
                if showCalendar { calendarView(proxy: proxy) } // 달력 뷰 자체
                
                if showMenu { menuView } // 메뉴 보기 모드일 때만 메뉴 뷰 표시
                
                // 눈 애니메이션이 켜져 있을 때
                if showSnow {
                    LottieView(fileName: "Snow", loopMode: .playOnce)  // 한 번만 재생되는 눈 애니메이션
                        .allowsHitTesting(false)   // 눈 애니메이션이 터치에 반응하지 않도록 설정
                        .ignoresSafeArea()         // 안전영역 무시하고 전체화면에 표시
                        .zIndex(1)                 // 가장 위에 표시
                        .onAppear {
                            // 애니메이션 시작 후 4초 뒤에 눈을 끔
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                showSnow = false
                            }
                        }
                }
            }
            
            // 사진 찍기 화면을 보여줄 때 실행됨
            .sheet(isPresented: $showCamera) {
                ImagePickerView { image in             // 이미지 선택 완료 후 실행되는 클로저
                    if let image = image {
                        selectedImages.append(image)   // 선택한 이미지를 배열에 추가
                        recognizeText(from: image)     // 이미지에서 글자 인식 (OCR)
                    }
                }
            }
            
            // 이미지 뷰어 화면 (여러 장의 사진을 넘겨보는 뷰)
            .sheet(isPresented: $showImageViewer) {
                TabView(selection: $selectedImageIndex) {
                    ForEach(selectedImages.indices, id: \.self) { i in
                        ZStack(alignment: .topTrailing) {
                            Color.black.ignoresSafeArea()       // 전체 배경을 검정색으로 설정
                            Image(uiImage: selectedImages[i])   // 해당 인덱스의 이미지 표시
                                .resizable()
                                .scaledToFit()                  // 이미지 크기 비율 유지하며 맞춤
                            Button(action: { showImageViewer = false }) {
                                Image(systemName: "xmark.circle.fill")   // 닫기 버튼 (X 모양)
                                    .font(.largeTitle)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle()) // 좌우로 넘기는 스타일 지정
            }
            
            // 저장 완료 시 나타나는 알림
            .alert("글이 저장되었습니다!", isPresented: $showSavedAlert) {
                Button("확인") { navigateToMain = true } // 확인 누르면 메인화면으로 이동
            }
            
            .alert("내용을 입력해주세요!", isPresented: $showEmptyTextAlert) {
                Button("확인", role: .cancel) {}
            }
            
            // 삭제 확인 알림
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                Button("삭제", role: .destructive) {
                    if let journal = editingJournal {
                        modelContext.delete(journal)        // 편집 중인 일기 삭제
                        try? modelContext.save()            // 저장소에 반영
                    }
                    navigateToMain = true                   // 메인화면으로 이동
                }
                Button("취소", role: .cancel) {}             // 취소 버튼
            }
            
            // NavigationLink를 활용해 메인 화면으로 이동하는 트리거
            .background(
                NavigationLink(destination: MainView(), isActive: $navigateToMain) {
                    EmptyView() // 화면에는 아무것도 보이지 않게 설정
                }
            )
            
            // 기본 뒤로가기 버튼 숨김 (커스텀 백버튼 사용 시 필요)
            .navigationBarBackButtonHidden(true)
        }
    }
    private var topBar: some View {
        HStack {  // 좌우로 아이템을 배치하는 수평 스택
            Button(action: { dismiss() }) { // 뒤로가기 버튼
                Image(systemName: "chevron.left") // 왼쪽 화살표 이미지
                    .font(.title2) // 아이콘 크기
                    .foregroundColor(.gray) // 회색 아이콘
                    .padding(.top, 10) // 위 여백
                    .padding(.leading, 12) // 왼쪽 여백
            }
            Spacer() // 가운데 공간 확보 (오른쪽 버튼을 끝으로 밀기 위함)
            Button(action: saveOrToggleMenu) { // 저장 or 메뉴 버튼
                Image(systemName: mode == .writing ? "checkmark" : "ellipsis") // 작성 중이면 체크, 아니면 점 3개
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.top, 12) // 전체 상단 여백
    }
    private var dateSelector: some View {
        VStack(spacing: 4) {
            Button(action: {
                if mode == .writing {
                    withAnimation { showCalendar.toggle() } // 달력 토글
                }
            }) {
                HStack(spacing: 6) {
                    Image("Calendar") // 달력 아이콘 이미지
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(.top, 8)
                    Text(formattedDate) // 날짜 텍스트
                        .font(.custom("NanumYuniDdingDdangDdingDdang", size: 28)) // 귀여운 폰트
                        .foregroundColor(Color("sBlue"))
                }
            }
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        self.dateButtonFrame = geo.frame(in: .named("JournalEntryViewSpace")) // 달력 위치 추적
                    }
                }
            )
        }
        .padding(.top, 16)
    }
    
    private var entryTextEditor: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TextEditor(text: $entryText) // 일기 쓰는 텍스트 입력창
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, selectedImages.isEmpty ? 20 : 0) // 이미지 없으면 여백 확보
                    .scrollContentBackground(.hidden)
                    .font(.custom("NanumYuniDdingDdangDdingDdang", size: 24))
                    .background(Color.clear)
                    .focused($isTextEditorFocused) // 포커스 여부 바인딩
                    .disabled(mode == .saving) // 저장 모드일 땐 입력 비활성화
                
                if !selectedImages.isEmpty {
                    imageThumbnailList // 이미지 썸네일 리스트 표시
                }
            }
            .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2)) // 연한 파란 배경
            .clipShape(RoundedRectangle(cornerRadius: 20)) // 모서리 둥글게
            
            if entryText.isEmpty {
                Text("마음에 울린 감사의 메아리를 적어보아요") // 입력창이 비었을 때 보여주는 안내 텍스트
                    .font(.custom("NanumYuniDdingDdangDdingDdang", size: 24))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 28)
                    .padding(.top, 28)
            }
        }
        .padding(.top, 20)
        .frame(height: 540) // 높이 고정
    }
    private var imageThumbnailList: some View {
        HStack(spacing: 8) {
            ForEach(Array(selectedImages.prefix(3).enumerated()), id: \.offset) { index, image in
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image) // 이미지 표시
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipped()
                        .cornerRadius(6)
                        .onTapGesture {
                            selectedImageIndex = index
                            showImageViewer = true // 이미지 전체 보기
                        }
                    
                    if mode == .writing {
                        Button(action: {
                            selectedImages.remove(at: index) // 이미지 삭제
                        }) {
                            Image("Cancel")
                                .resizable()
                                .frame(width: 24, height: 24)
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
                        .frame(width: 70, height: 70)
                        .clipped()
                        .cornerRadius(6)
                        .overlay(Color.black.opacity(0.4).cornerRadius(6))
                        .onTapGesture {
                            selectedImageIndex = index
                            showImageViewer = true
                        }
                    
                    Text("+\(selectedImages.count - 3)") // 남은 개수 표시
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 18)
    }
    
    private var imageButtons: some View {
        HStack(spacing: 12) {
            
            Button(action: { showCamera = true }) {
                Image("Camera")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            PhotosPicker(selection: $imageSelections, maxSelectionCount: 10, matching: .images) {
                Image("Media")
                    .resizable()
                    .frame(width: 33, height: 30)
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
        Color.black.opacity(0.001) // 거의 투명한 클릭 감지용 배경
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation { showCalendar = false }
            }
    }
    
    private func calendarView(proxy: GeometryProxy) -> some View {
        VStack {
            DatePicker("", selection: $currentDate, displayedComponents: [.date]) // 날짜 선택
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
            // ✅ 글자가 하나라도 없으면 저장을 막고 경고창 띄우기
            if entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                // 저장 경고 알림을 띄우기 위해 별도의 alert 상태를 새로 만들 수도 있음
                showSavedAlert = false // 이미 뜬 알림은 닫고
                showEmptyTextAlert = true // ➕ 새로 추가할 alert 상태
                return
            }

            if let journal = editingJournal {
                // 기존 일기 수정
                journal.date = currentDate
                journal.content = entryText
                journal.imageDataArray = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
            } else {
                // 새 일기 생성
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

    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { request, _ in
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let recognized = observations.compactMap {
                    $0.topCandidates(1).first?.string
                }.joined(separator: "\n")
                DispatchQueue.main.async {
                    entryText += (entryText.isEmpty ? "" : "\n") + recognized
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["ko-KR"] // ✅ 한국어로 OCR 수행
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

////  WritingView.swift
////  Thancho2
////
////  Created by 박지희 on 4/15/25.

import SwiftUI
import PhotosUI

enum ModeType: String {
    case writing = "Writing"
    case saving = "Saving"
}

struct JournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var mode: ModeType = .writing
    @State private var currentDate: Date = Date()
    @State private var entryText: String = ""
    @State private var showCalendar: Bool = false
    @State private var showMenu: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @State private var selectedImages: [UIImage] = []
    @State private var showImageViewer: Bool = false
    @State private var selectedImageForViewer: UIImage? = nil
    @State private var imageSelections: [PhotosPickerItem] = []

    @State private var dateButtonFrame: CGRect = .zero

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: currentDate)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    // MARK: - 상단 바
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                                .padding(.top, 10)
                                .padding(.leading, 12)
                        }

                        Spacer()

                        Button(action: {
                            if mode == .writing {
                                mode = .saving
                            } else {
                                withAnimation {
                                    showMenu.toggle()
                                }
                            }
                        }) {
                            if mode == .writing {
                                Image(systemName: "checkmark")
                                    .font(.title2)
                                    .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                                    .padding(.top, 5)
                                    .padding(.horizontal, 12)
                            } else {
                                Image("menu")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .padding(.top, 5)
                                    .padding(.horizontal, 12)
                            }
                        }
                    }
                    .padding(.top, 12)

                    // MARK: - 날짜 + 버튼 위치 추적
                    VStack(spacing: 4) {
                        Button(action: {
                            withAnimation {
                                showCalendar.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image("Calendar")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                Text(formattedDate)
                                    .font(.custom("NanumYuniDdingDdangDdingDdang", size: 32))
                                    .foregroundColor(.black)
                            }
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        self.dateButtonFrame = geo.frame(in: .global)
                                    }
                            }
                        )
                    }
                    .padding(.top, 16)

                    // MARK: - 본문 작성 영역
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
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    if mode == .saving {
                                                        selectedImageForViewer = image
                                                        showImageViewer = true
                                                    }
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

                                    if selectedImages.count > 4 {
                                        let remaining = selectedImages.count - 4
                                        ZStack {
                                            Image(uiImage: selectedImages[4])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .clipped()
                                                .cornerRadius(10)
                                                .onTapGesture {
                                                    if mode == .saving {
                                                        selectedImageForViewer = selectedImages[4]
                                                        showImageViewer = true
                                                    }
                                                }

                                            Rectangle()
                                                .foregroundColor(Color.black.opacity(0.5))
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(10)

                                            Text("+\(remaining)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 14, weight: .bold))
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 18)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        if entryText.isEmpty {
                            Text("마음에 울린 감사의 메아리를 적어보아요")
                                .font(.custom("NanumYuniDdingDdangDdingDdang", size: 27))
                                .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                                .padding(.horizontal, 28)
                                .padding(.top, 28)
                        }
                    }
                    .padding(.top, 20)
                    .frame(height: 540)

                    // MARK: - 이미지 추가 버튼
                    if mode == .writing {
                        HStack(spacing: 9) {
                            Button(action: {
                                // 카메라
                            }) {
                                Image("Camera")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }

                            PhotosPicker(
                                selection: $imageSelections,
                                maxSelectionCount: 10,
                                matching: .images
                            ) {
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

                    Spacer()
                }
                .padding(.horizontal, 24)

                // MARK: - Floating 달력
                if showCalendar {
                    VStack {
                        DatePicker("", selection: $currentDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .tint(.pBlue) // ✅ pBlue 색상 (#80AFD7)
                            .padding(.vertical, 4) // ✅ 위아래 여백
                            .padding(.horizontal, 12) // ✅ 좌우 여백으로 자연스럽게 폭 조정
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 6)
                            .onChange(of: currentDate) { _ in
                                withAnimation {
                                    showCalendar = false
                                }
                            }
                    }
                    .frame(width: 320) // ✅ 전체 DatePicker 크기 조정은 여기서!
                    .position(x: proxy.size.width / 2, y: dateButtonFrame.maxY + 114)
                    .transition(.opacity)
                }


                // MARK: - 메뉴
                if showMenu {
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
                        withAnimation {
                            showMenu = false
                        }
                    }
                }
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    entryText = ""
                    selectedImages = []
                    mode = .writing
                }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showImageViewer) {
                if let selected = selectedImageForViewer {
                    ZStack(alignment: .topTrailing) {
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    JournalEntryView()
}

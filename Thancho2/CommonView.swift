////  WritingView.swift
////  Thancho2
////
////  Created by 박지희 on 4/15/25.

import SwiftUI

enum ModeType: String {
    case writing = "Writing"
    case saving = "Saving"
}

struct JournalEntryView: View {
    
    @State private var mode: ModeType = .writing
    @State private var currentDate: Date = Date()
    @State private var entryText: String = ""
    @State private var showCalendar: Bool = false
    @State private var showMenu: Bool = false
    @State private var showDeleteAlert: Bool = false

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: currentDate)
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 상단 바
                HStack {
                    Button(action: {}) {
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

                // 날짜 + 캘린더 버튼
                VStack(alignment: .center, spacing: 4) {
                    Button(action: {
                        withAnimation {
                            showCalendar.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image("Calendar")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                                .padding(.top, 10)
                            Text(formattedDate)
                                .font(.custom("NanumYuniDdingDdangDdingDdang", size: 32))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.top, 16)

                // 글쓰기 배경
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $entryText)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scrollContentBackground(.hidden)
                        .font(.custom("NanumYuniDdingDdangDdingDdang", size: 24))
                        .background(Color(red: 0.5, green: 0.69, blue: 0.84).opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
                        .disabled(mode == .saving)

                    if entryText.isEmpty {
                        Text("마음에 울린 감사의 메아리를 적어보아요")
                            .font(Font.custom("Nanum YuNiDdingDdangDdingDdang", size: 27))
                            .foregroundColor(Color(red: 0.33, green: 0.39, blue: 0.42))
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .lineLimit(1)
                    }
                }
                .padding(.top, 20)
                .frame(height: 540)

                // 하단 버튼
                if mode == .writing {
                    HStack(spacing: 9) {
                        Button(action: {}) {
                            Image("Camera")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }

                        Button(action: {}) {
                            Image("Media")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }

                        Spacer()
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                }

                Spacer()
            }
            .padding(.horizontal, 24)

            // 캘린더 팝업
            if showCalendar {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showCalendar = false
                            }
                            
                        }
                    
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

            // 드롭다운 메뉴
            if showMenu {
                VStack {
                    HStack {
                        Spacer()

                        VStack(spacing: 0) {
                            Button(action: {
                                mode = .writing
                                withAnimation {
                                    showMenu = false
                                }
                            }) {
                                Text("수정하기")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.black)
                            }

                            Divider()

                            Button(action: {
                                withAnimation {
                                    showMenu = false
                                }
                                showDeleteAlert = true
                            }) {
                                Text("삭제하기")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.red)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(width: 120)
                        .padding(.trailing, 12)
                        .padding(.top, 70)
                        .transition(.move(edge: .top).combined(with: .opacity))
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
        // 삭제 알림창
        .alert("정말 삭제할까요?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                // 삭제 로직
                print("삭제됨")
                entryText = ""
                mode = .writing
            }
            Button("Cancel", role: .cancel) {
                // 취소
            }
        }
    }
}

#Preview {
    JournalEntryView()
}

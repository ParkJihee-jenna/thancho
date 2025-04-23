////
////  Journal.swift
////  Thancho
////
////  Created by 박지희 on 4/20/25.
////
///
import Foundation      // 날짜(Date) 타입 등 기본 기능을 사용하기 위한 프레임워크
import SwiftData       // SwiftData를 사용해 앱 내에 데이터를 저장하기 위한 프레임워크

// @Model은 이 클래스가 SwiftData에서 저장 가능한 데이터라는 걸 나타냄
@Model
class Journal { // 일기 데이터를 저장할 모델 클래스

    // 일기의 날짜 (예: 2025년 4월 23일)
    var date: Date

    // 일기의 내용 (텍스트)
    var content: String

    // 일기에 첨부된 이미지들을 저장 (UIImage → Data 형식으로 변환해서 저장)
    var imageDataArray: [Data]

    // 이니셜라이저(초기화 함수) - 이 클래스를 만들 때 어떤 값을 넣을지 정해줌
    init(date: Date, content: String, imageDataArray: [Data] = []) {
        self.date = date                           // 전달받은 날짜로 설정
        self.content = content                     // 전달받은 텍스트로 설정
        self.imageDataArray = imageDataArray       // 전달받은 이미지 배열로 설정 (없으면 빈 배열)
    }

    // 샘플 데이터를 위한 정적 속성 (미리보기 등에 사용됨)
    static var sample: Journal {
        // 오늘 날짜와 빈 내용, 빈 이미지 배열을 가진 Journal 객체 하나 반환
        Journal(date: Date(), content: "", imageDataArray: [])
    }
}

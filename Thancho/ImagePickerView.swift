//
//  ImagePickerView.swift
//  Thancho
//
//  Created by 박지희 on 4/22/25.
//

import SwiftUI        // SwiftUI 사용 (화면 UI를 만들기 위한 프레임워크)
import UIKit          // UIKit 사용 (iOS의 전통적인 UI 구성 도구, 카메라 등은 여기서 다룸)

// SwiftUI에서 UIKit의 UIImagePickerController를 사용하게 해주는 구조체
struct ImagePickerView: UIViewControllerRepresentable {

    // 사진을 찍은 후 결과를 반환할 클로저 (UIImage?는 사진이 있거나 없을 수 있음)
    var completion: (UIImage?) -> Void

    // Coordinator 생성: SwiftUI와 UIKit 사이를 연결해주는 중간 관리자
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completion)  // completion 클로저를 전달
    }

    // 실제 UIKit의 카메라 뷰컨트롤러를 생성하는 함수
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()      // 카메라 뷰컨트롤러 객체 생성
        picker.sourceType = .camera                 // 사진 촬영 모드로 설정 (카메라 사용)
        picker.delegate = context.coordinator       // 이벤트 처리를 Coordinator에게 맡김
        picker.allowsEditing = false                // 사진 편집 기능 비활성화
        return picker
    }

    // SwiftUI에서 UIKit 컨트롤러가 업데이트될 때 호출됨 (여기선 별도 작업 없음)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // Coordinator 클래스 정의: 사진 찍기 완료/취소 시 동작 정의
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var completion: (UIImage?) -> Void  // 결과를 전달할 클로저 저장

        init(completion: @escaping (UIImage?) -> Void) {
            self.completion = completion    // 외부에서 전달받은 클로저 저장
        }

        // 사용자가 사진을 찍고 선택을 완료했을 때 호출되는 메서드
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            let image = info[.originalImage] as? UIImage  // 원본 이미지를 꺼냄
            picker.dismiss(animated: true) {              // 카메라 화면을 닫고
                self.completion(image)                    // 찍은 이미지를 반환
            }
        }

        // 사용자가 사진 찍기를 취소했을 때 호출되는 메서드
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {              // 카메라 화면을 닫고
                self.completion(nil)                      // nil을 반환 (아무 것도 선택되지 않음)
            }
        }
    }
}

//  CameraPicker.swift
//  Thancho
//
//  Created by 박지희 on 4/22/25.

import SwiftUI  // SwiftUI 프레임워크: 현대적인 iOS 앱 UI 만들기용

struct CameraPicker: UIViewControllerRepresentable { //UIViewControllerRepresentable은 SwiftUI에서 UIKit의 뷰 컨트롤러를 사용할 수 있게 해주는 브리지 역할을 해요. 여기서는 카메라를 띄우기 위해 사용합니다.
    var imageHandler: (UIImage?) -> Void //사용자가 사진을 찍고 나서 그 이미지를 밖으로 보내줄 함수 (클로저)예요. 이미지가 없으면 nil이 전달됩니다.

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }//SwiftUI는 UIKit과 통신할 때 중간 관리자(Coordinator)**가 필요해요. 여기서는 Coordinator 클래스를 만들어서 연결합니다.

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate { //Coordinator는 카메라에서 사용자가 사진을 찍거나 취소했을 때, 그 결과를 처리해주는 클래스입니다.
        let parent: CameraPicker  // 부모 구조체(CameraPicker)를 저장

        init(_ parent: CameraPicker) {
            self.parent = parent  // 부모를 초기화할 때 저장해둠
        }
        // 사용자가 사진을 찍고 확인했을 때 호출되는 함수
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            let image = info[.originalImage] as? UIImage // 찍은 원본 이미지 가져오기
            parent.imageHandler(image)                   // 부모에게 이미지 전달
            picker.dismiss(animated: true)               // 카메라 화면 닫기
        }

        // 사용자가 사진 찍기를 취소했을 때 호출되는 함수
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)               // 그냥 카메라 화면만 닫기
        }
    }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()  // UIKit의 이미지 피커(카메라) 생성
        picker.delegate = context.coordinator   // 이벤트 처리 담당자 지정
        picker.sourceType = .camera             // 소스를 "카메라"로 지정 (앨범 아님!)
        return picker                           // 만든 카메라 뷰 리턴
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}//SwiftUI에서 해당 UIKit 뷰컨트롤러를 업데이트할 일이 없을 때는 이렇게 빈 상태로 둬도 괜찮아요.

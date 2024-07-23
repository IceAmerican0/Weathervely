//
//  UITextField+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/11.
//

import UIKit
import FlexLayout
import Then

extension UITextField {
    
    /// 자동완성이나 스마트 대시 등을 없애고 키보드 영역을 깔끔하게 만들기 위해서 사용
    static func neatKeyboard() -> UITextField {
        UITextField().then {
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.smartDashesType = .no
            $0.smartQuotesType = .no
            $0.smartInsertDeleteType = .no
            $0.spellCheckingType = .no
            $0.returnKeyType = .done
        }
    }
    
    enum editMode {
        case justShow
        case editing
    }
    
    func setEditMode(_ editMode: editMode) {
        if editMode == .justShow {
            self.isEnabled = false
        } else {
            self.isEnabled = true
        }
    }
    
    func setClearButton(_ image: UIImage?, _ viewMode: UITextField.ViewMode) {
        
        guard image != nil else {
            return
        }
        let imageView = UIButton(type: .custom)
        imageView.setImage(image, for: .normal)
        
        imageView.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.displayClearButtonIfNeeded), for: .editingChanged)
        
        self.rightView = imageView
        self.rightViewMode = viewMode
        
    }
    
    @objc func clear() {
        guard let text else { return }
        
        if !text.isEmpty {
            self.text?.removeAll()
            sendActions(for: .editingChanged)
        }
    }
    
    @objc
       private func displayClearButtonIfNeeded() {
           if !((self.text?.isEmpty) ?? true) {
               self.rightView?.isHidden = false
           } else {
               self.rightView?.isHidden = true
           }
       }
    
}

extension UITextFieldDelegate {
    /// 닉네임 유효성 체크 >> 통과 못할시 에러메시지 반환
    func nicknameValidationCheck(_ textField: UITextField, _ range: NSRange, _ string: String) -> String? {
        /// 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return nil }
        }
        /// 글자수 제한
        guard let text = textField.text else { return "" }
        guard text.count < 10 else { return "닉네임은 최대 10글자에요" }
        
        /// 띄어쓰기 제한
        if string == " " {
            return "띄어쓰기는 불가해요"
        }
        /// 특수기호 제한
        let disallowedCharacterSet = CharacterSet(charactersIn: "₩!@#$%^&*()_-+=[]{}|\\:;\"'<>,.?/~`")
        if string.rangeOfCharacter(from: disallowedCharacterSet) != nil {
            return "사용 불가 문자가 포함됐어요"
        }
        
        // 한글, 영어 외 외국어 제한
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZㄱ-ㅎㅏ-ㅣ가-힣")
        if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
            return "한글 및 영어만 사용 가능해요"
        }
        
        return nil
    }
}

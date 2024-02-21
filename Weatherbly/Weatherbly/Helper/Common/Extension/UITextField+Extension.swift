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
    func customTextField(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool {
        /// 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        /// 글자수 제한
        guard let text = textField.text else { return false }
        guard text.count < 10 else { return false }
        /// 특수기호 제한
        let disallowedCharacterSet = CharacterSet(charactersIn: "₩!@#$%^&*()_-+=[]{}|\\:;\"'<>,.?/~`")
        /// 띄어쓰기 제한
        return string != " " && string.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}

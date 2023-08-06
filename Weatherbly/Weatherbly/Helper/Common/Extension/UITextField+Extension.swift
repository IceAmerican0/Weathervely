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
        
        guard let text = self.text else {
            return
        }
        
        if !text.isEmpty {
            self.text?.removeAll()
            sendActions(for: .editingChanged)
        }
    }
    
    @objc
       private func displayClearButtonIfNeeded() {
           self.rightView?.isHidden = (self.text?.isEmpty) ?? true
       }
    
}



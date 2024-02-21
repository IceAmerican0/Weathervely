//
//  UIViewController+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/10.
//

import UIKit

extension UIViewController {
    func gestureEndEditing() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {}
    @objc func keyboardWillHide(_ notification: Notification) {}
}

// MARK: Custom BottomSheet
extension UIViewController {
    /// 높이 커스텀 가능한 BottomSheet >> default = 500
    func setBottomSheet(SheetHeight: CGFloat = Constants.screenHeight * 0.61) {
        if let sheet = sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("custom")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { _ in
                SheetHeight
            }
            
            sheet.detents = [customDetent]
        }
    }
}

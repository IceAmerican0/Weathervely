//
//  SettingRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/10.
//

import UIKit
import PinLayout
import FlexLayout

final class SettingRegionViewController: BaseViewController {
    
    private var progressBar = CSProgressView(0.25)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private var explanationLabel = CSLabel(.bold, 25, "동네를 설정해주세요")
    private var inputRegion = UITextField()
    private var buttonWrapper = UIView()
    private var confirmButton = CSButton(.primary)
    
    private let textFieldMarginHeight = UIScreen.main.bounds.height * 0.186
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        gestureEndEditing()
        
        inputRegion.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func attribute() {
        super.attribute()
        
        navigationView.do {
            $0.setTitle("")
            $0.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        explanationLabel.do {
            $0.backgroundColor = .white
        }
        
        inputRegion.do {
            $0.placeholder = "동네 이름(동, 읍, 면)으로 검색"
            $0.textAlignment = .center
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView)
            flex.addItem(explanationLabel).marginTop(27)
            flex.addItem(inputRegion).marginTop(textFieldMarginHeight).width(330).height(50)
            flex.addItem(confirmButton).width(88%).height(62)
        }
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapConfirmButton() {
        self.navigationController?.pushViewController(SelectGenderViewController(), animated: true)
    }
    
    // MARK: Keyboard Action
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                confirmButton.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}

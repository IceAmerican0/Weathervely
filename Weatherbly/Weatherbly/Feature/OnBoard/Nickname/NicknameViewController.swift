//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import UIKit
import FlexLayout
import PinLayout

final class NicknameViewController: RxBaseViewController<NicknameViewModel> {
    
    private var progressBar = CSProgressView(0.2)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private var explanationLabel = CSLabel(.bold, 25, "닉네임을 설정해주세요")
    private var guideLabel = CSLabel(.bold, 20, "(5글자 이내)")
    private var inputNickname = UITextField()
    private var confirmButton = CSButton(.primary)
    
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputNickname.becomeFirstResponder()
        
        registerKeyboardNotifications()
        gestureEndEditing()
    }
    
    override func attribute() {
        super.attribute()
        
        explanationLabel.do {
            $0.backgroundColor = .white
        }
        
        inputNickname.do {
            $0.placeholder = "감자,뽀롱이,써니... 뭐든 좋아요! :)"
            $0.textAlignment = .center
            $0.backgroundColor = CSColor._248_248_248.color
            $0.layer.cornerRadius = 13
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(explanationLabel).marginTop(27)
            flex.addItem(guideLabel)
            flex.addItem(inputNickname).marginTop(36).width(330).height(50)
            flex.addItem(confirmButton).width(88%).height(62)
        }
        confirmButton.pin.bottom(buttonMarginBottom)
    }
    
    override func viewBinding() {
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        // TODO: 닉네임 입력 로직 만들기
        confirmButton.rx.tap
            .map { SettingRegionViewController(SettingRegionViewModel()) }
            .bind(to: viewModel.navigationPushViewControllerRelay)
            .disposed(by: bag)
    }
    
    // MARK: Keyboard Action
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            confirmButton.pin.bottom(keyboardSize.height + 30)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}

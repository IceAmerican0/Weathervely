//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import Then

final class NicknameViewController: RxBaseViewController<NicknameViewModel> {
    private var progressBar = CSProgressView(0.33)
    
    private var navigationView = CSNavigationView(.leftButton(.navi_back)).then {
        $0.setTitle("닉네임 설정")
    }
    
    private var explanationLabel = LabelMaker(
        font: .heading_5_B
    ).make(text: "닉네임을 설정해 주세요")
    
    private var guideLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .gray60
    ).make(text: "10글자 이내 / 띄어쓰기, 쉼표 불가")
    
    private lazy var inputNickname = CSTextField().then {
        $0.delegate = self
        $0.setPlaceholder(
            text: "감자, 뽀롱이, 써니 등 뭐든 좋아요! :-)",
            font: .body_3_M
        )
        $0.becomeFirstResponder()
    }
    
    private var confirmButton = NewCSButton(.standard, style: .violet600).then {
        $0.setTitle("확인", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(progressBar)
            $0.addItem(navigationView).width(100%)
            $0.addItem(explanationLabel).marginTop(50).marginLeft(20)
            $0.addItem(guideLabel).marginTop(8).marginLeft(20)
            $0.addItem(inputNickname).alignSelf(.stretch).marginTop(32).marginHorizontal(20).height(40)
            $0.addItem(confirmButton).position(.absolute).bottom(20).marginHorizontal(20).height(48)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.getInputNickname()
            }.disposed(by: bag)
        
        inputNickname.rx.text.orEmpty
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, text in
                    if text.count > 1 {
                        owner.confirmButton.isEnabled = true
                    } else {
                        owner.confirmButton.isEnabled = false
                    }
                }
            ).disposed(by: bag)
        
        viewModel.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(
                with: self,
                onNext: { owner, message in
                    owner.inputNickname.setErrorMessage(message: message)
                }
            ).disposed(by: bag)
    }
    
    private func getInputNickname() {
        if let text = inputNickname.text {
            viewModel.didTapConfirmButton(text)
        }
    }
}

// MARK: UITextFieldDelegate
extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let message = nicknameValidationCheck(textField, range, string) {
            viewModel.errorMessage.accept(message)
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getInputNickname()
        return true
    }
}

// MARK: Keyboard Action
extension NicknameViewController {
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            confirmButton.flex.bottom(keyboardSize.height)
            container.flex.layout()
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        confirmButton.flex.bottom(20)
        container.flex.layout()
    }
}

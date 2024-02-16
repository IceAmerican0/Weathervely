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

final class NicknameViewController: RxBaseViewController<NicknameViewModel> {
    
    private var progressBar = CSProgressView(0.33)
    private var navigationView = CSNavigationView(.leftButton(.navi_back))
    private var explanationLabel = CSLabel(.bold, 25, "닉네임을 설정해주세요")
    private var guideLabel = CSLabel(.bold, 20, "(10글자 이내 / 띄어쓰기, 쉼표 불가)")
    private var inputNickname = UITextField.neatKeyboard()
    private var confirmButton = CSButton(.grayFilled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        gestureEndEditing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyboardNotifications()
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
            $0.delegate = self
            $0.setClearButton(AssetsImage.delete.image, .whileEditing)
            $0.becomeFirstResponder()
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.isEnabled = false
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(explanationLabel).marginTop(27)
            flex.addItem(guideLabel).marginTop(10)
            flex.addItem(inputNickname).marginTop(36).width(85%).height(50)
            flex.addItem(confirmButton).position(.absolute).bottom(10%).marginHorizontal(43).width(78%).height(62)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.getInputNickname()
            }
            .disposed(by: bag)
        
        inputNickname.rx.text.orEmpty
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, text in
                    if text.count > 1 {
                        owner.confirmButton.isEnabled = true
                        owner.confirmButton.setButtonStyle(.primary)
                    } else {
                        owner.confirmButton.isEnabled = false
                        owner.confirmButton.setButtonStyle(.grayFilled)
                    }
            })
            .disposed(by: bag)
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
        customTextField(textField, range, string)
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
            confirmButton.pin.bottom(keyboardSize.height + 30)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        confirmButton.pin.bottom(10%)
    }
}

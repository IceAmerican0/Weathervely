//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import DesignSystem
import UIUtil
import UIKit

public protocol NicknameViewDelegate {
    func backButtonTapped()
    func nicknameEntered(nickname: String)
    func nicknameOnboardCompleted()
    func nicknameCompleted()
}

public final class NicknameViewController: RxBaseViewController<NicknameViewModel> {
    
    private let viewState = UserDefaultManager.shared.isOnBoard ? "설정" : "수정"
    
    private lazy var navigationView = CSNavigationView(.leftOnly(.leftArrow_black)).then {
        $0.setTitle("닉네임 \(viewState)")
    }
    
    private lazy var explanationLabel = LabelMaker(
        font: .heading_5_B
    ).make(text: "닉네임을 \(viewState)해 주세요")
    
    private var guideLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .gray60
    ).make(text: "10글자 이내 / 띄어쓰기, 특수문자 불가")
    
    private lazy var inputNickname = CSTextField().then {
        $0.delegate = self
        $0.setPlaceholder(
            text: "감자, 뽀롱이, 써니 등 뭐든 좋아요! :-)",
            font: .body_3_M
        )
    }
    
    private var buttonView = UIView()
    
    private var confirmButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("확인", for: .normal)
    }
    
    var delegate: NicknameViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputNickname.becomeFirstResponder()
    }
    
    public override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView)
            $0.addItem(explanationLabel).marginTop(50).marginLeft(20)
            $0.addItem(guideLabel).marginTop(8).marginLeft(20)
            $0.addItem(inputNickname).alignSelf(.stretch).marginTop(32).marginHorizontal(20).height(40)
            $0.addItem(confirmButton).position(.absolute).alignSelf(.stretch).bottom(20).horizontally(20).height(48)
        }
    }
    
    public override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.delegate?.backButtonTapped()
            }).disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.getInputNickname()
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
        
        viewModel.savedNickname
            .asDriver(onErrorJustReturn: "")
            .drive(
                with: self,
                onNext: { owner, nickname in
                    owner.delegate?.nicknameEntered(nickname: nickname)
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
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let message = nicknameValidationCheck(textField, range, string) {
            viewModel.errorMessage.accept(message)
            return false
        } else {
            viewModel.errorMessage.accept("")
            return true
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getInputNickname()
        return true
    }
}

// MARK: Keyboard Action
extension NicknameViewController {
    public override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            confirmButton.flex.bottom(keyboardSize.height)
            container.flex.layout()
            container.layoutIfNeeded()
        }
    }
}

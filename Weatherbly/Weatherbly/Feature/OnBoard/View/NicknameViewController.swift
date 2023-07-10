//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import UIKit
import FlexLayout
import PinLayout

final class NicknameViewController: BaseViewController {
    
    private var progressBar = CSProgressView(0.25)
    private var backButton = UIButton()
    private var explanationLabel = CSLabel(.bold, 25, "닉네임을 설정해주세요")
    private var guideLabel = CSLabel(.bold, 20, "(5글자 이내)")
    private var inputNickname = UITextField()
    private var buttonWrapper = UIView()
    private var confirmButton = CSButton(.primary)
    
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonWrapper)
        view.bringSubviewToFront(container)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        inputNickname.becomeFirstResponder()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func attribute() {
        super.attribute()
        
        backButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        explanationLabel.do {
            $0.backgroundColor = .white
        }
        
        inputNickname.do {
            $0.placeholder = "감자,뽀롱이,써니... 뭐든 좋아요! :)"
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
            flex.addItem(backButton).alignSelf(.start).marginTop(15).left(12).size(44)
            flex.addItem(explanationLabel).marginTop(27)
            flex.addItem(guideLabel)
            flex.addItem(inputNickname).marginTop(36).width(330).height(50)
            flex.addItem(confirmButton).width(88%).height(62)
        }
        
        confirmButton.pin.bottom(buttonMarginBottom)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapConfirmButton() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    // MARK: Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                confirmButton.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}

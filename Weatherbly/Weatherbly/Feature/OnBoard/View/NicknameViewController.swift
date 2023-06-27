//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import UIKit
import FlexLayout

final class NicknameViewController: BaseViewController {
    
    private var progressBar = CSProgressView(0.25)
    private var backButton = UIImageView()
    private var explanationLabel = CSLabel(.bold, 25, "닉네임을 설정해주세요")
    private var guideLabel = CSLabel(.bold, 20, "(5글자 이내)")
    private var inputNickname = UITextField()
    private var confirmButton = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        backButton.do {
            $0.image = AssetsImage.navigationBackButton.image
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
    }
    
    @objc private func didTapConfirmButton() {
        
    }
}

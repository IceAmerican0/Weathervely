//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import UIKit

final class NicknameViewController: BaseViewController {
    
    private lazy var progressBar = UIProgressView()
    private lazy var explanationLabel = CSLabel(.primary)
    private lazy var guideLabel = CSLabel(.primary)
    private lazy var inputNickname = UITextField()
    private lazy var confirmButton = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        progressBar.do {
            $0.backgroundColor = .black
        }
        
        explanationLabel.do {
            $0.text = "닉네임을 설정해주세요"
        }
        
        guideLabel.do {
            $0.text = "(5글자 이내)"
            $0.font = .boldSystemFont(ofSize: 20)
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
        
        container.flex.alignItems(.center).marginTop(36)
            .define { flex in
                flex.addItem(explanationLabel)
                flex.addItem(guideLabel)
                flex.addItem(inputNickname).marginTop(25).width(330).height(50)
                flex.addItem(confirmButton).marginTop(413).width(304).height(62)
        }
    }
    
    @objc private func didTapConfirmButton() {
        
    }
}

//
//  NicknameViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/14.
//

import UIKit

final class NicknameViewController: BaseViewController {
    
    private lazy var upperNavigationContainer = UIView()
    private lazy var progressBar = CSProgressView(.bar)
    private lazy var explanationLabel = CSLabel(.bold,
                                                labelText: "닉네임을 설정해주세요",
                                                labelFontSize: 25)
    private lazy var guideLabel = CSLabel(.bold,
                                          labelText: "(5글자 이내)",
                                          labelFontSize: 20)
    private lazy var inputNickname = UITextField()
    private lazy var confirmButton = CSButton(.primary)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // TODO: progressView 위치 조정
        let navigationBarTop = view.pin.safeArea.top - (navigationController?.navigationBar.frame.size.height ?? 0)
        
        upperNavigationContainer.pin.top(navigationBarTop).left().right()
        upperNavigationContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(upperNavigationContainer)
    }
    
    override func attribute() {
        super.attribute()
        
        progressBar.do {
            $0.progress = 0.25
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
        
        upperNavigationContainer.flex.define { flex in
            flex.addItem(progressBar)
        }
        
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

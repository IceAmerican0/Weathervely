//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import FlexLayout
import PinLayout

final class OnBoardViewController: BaseViewController {
    
    private var topGreetingLabel = CSLabel(.bold, 25, "날씨블리에 오신 걸\n환영해요!")
    private var logo = UIImageView()
    private var bottomGreetingLabel = CSLabel(.bold, 20, "날씨블리가 날씨에 맞는\n옷차림을 알려드릴 거에요")
    private var startButton = CSButton(.primary)
    private var buttonHeight = UIScreen.main.bounds.height * 0.07
    
    override func attribute() {
        super.attribute()
        
        logo.do {
            $0.image = UIImage(systemName: "star.fill")
            
        }
        
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        }
        
    }
    
    override func layout() {
        super.layout()
    
        container.flex
//            .alignItems(.center)
            .justifyContent(.spaceAround)
            .define { flex in
                flex.addItem(topGreetingLabel)
                flex.addItem(logo).width(35%).height(23%).alignSelf(.center)
                flex.addItem(bottomGreetingLabel)
                flex.addItem(startButton).height(buttonHeight).define { flex in
                    flex.marginHorizontal(43)
                        .height(startButton.primaryHeight)
//                    startButton.pin.left(43).right(43)
                }
        }
    }
    
    @objc private func didTapStartButton() {
        self.navigationController?.pushViewController(ChangeNicknameViewController(), animated: true)
    }

}

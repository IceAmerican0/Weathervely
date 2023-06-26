//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit

final class OnBoardViewController: BaseViewController {
    
    private var contentView = UIView()
    private var topGreetingLabel = CSLabel(.bold,
                                           labelText: "날씨블리에 오신 걸\n환영해요!",
                                           labelFontSize: 25)
    private var logo = UIImageView()
    private var bottomGreetingLabel = CSLabel(.bold,
                                              labelText: "날씨블리가 날씨에 맞는\n옷차림을 알려드릴 거에요",
                                              labelFontSize: 20)
    private var startButton = CSButton(.primary)
    
    
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
    
        container.flex.alignItems(.center).define { flex in
            flex.addItem(topGreetingLabel)
            flex.addItem(logo).minHeight(201)
            flex.addItem(bottomGreetingLabel)
            flex.addItem(startButton).width(304).height(62)
        }
        
    /// 비율? 인지 모든 디바이스에서 어떻게 작동하는 것이 옳은것인지 더 찾아볼 필요가있다.
    /// CGFloat 픽셀 기반이라 기본적으로 다른 디바이스에서도 똑같이 보이는게 맞는데
        topGreetingLabel.pin.top(36).left(30).right(30)
        logo.pin.top(to: topGreetingLabel.edge.bottom).marginTop(58).left(126).right(126)
        bottomGreetingLabel.pin.top(to: logo.edge.bottom).marginTop(100).left(95).right(95)
        startButton.pin.top(to: bottomGreetingLabel.edge.bottom).marginTop(69).left(43).right(43)
    
    }
    
    @objc private func didTapStartButton() {
        self.navigationController?.pushViewController(SensoryTempViewController(), animated: true)
    }
}

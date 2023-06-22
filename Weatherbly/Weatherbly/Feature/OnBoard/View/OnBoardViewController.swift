//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import Then

final class OnBoardViewController: BaseViewController {
    
    
    private var topGreetingLabel = UILabel()
    
    private var logoWrapper = UIView()
    private var logo = UIImageView()
    private var bottomGreetingLabel = UILabel()
    private var startButton = CSButton(.primary)
    
    
    override func attribute() {
        super.attribute()
        
        topGreetingLabel.do {
            $0.text = "날씨블리에 오신 걸\n환영해요!"
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 25)
            
        }
        
        logoWrapper.do {
            $0.backgroundColor = .yellow
        }
        
        logo.do {
            $0.image = UIImage(systemName: "star.fill")

        }
        
        bottomGreetingLabel.do {
            $0.text = "날씨블리가 날씨에 맞는\n옷차림을 알려드릴 거예요"
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 20)
            
            
        }
        
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        }
        
    }
    
    override func layout() {
        
    
        container.flex.alignItems(.center).define { flex in
            flex.addItem(topGreetingLabel).marginTop(94).marginHorizontal(30)
            flex.addItem(logo)
            flex.addItem(bottomGreetingLabel)
            flex.addItem(startButton).width(304).height(62).marginTop(69).marginHorizontal(43)
        }
        
        
    /// 비율? 인지 모든 디바이스에서 어떻게 작동하는 것이 옳은것인지 더 찾아볼 필요가있다.
    /// CGFloat 픽셀 기반이라 기본적으로 다른 디바이스에서도 똑같이 보이는게 맞는데
    
        topGreetingLabel.pin.top(93).left(30).right(30)
        logo.pin.top(view.pin.safeArea).marginTop(225).bottom(view.pin.safeArea).marginBottom(340).horizontally(95)
        bottomGreetingLabel.pin.top(to: logo.edge.bottom).marginTop(100).left(95).right(95)
        startButton.pin.top(to: bottomGreetingLabel.edge.bottom).marginTop(69).left(43).right(43)
    }
    
    @objc private func didTapStartButton() {
        self.navigationController?.pushViewController(SensoryTempViewController(), animated: true)
    }
}

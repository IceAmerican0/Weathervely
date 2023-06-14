//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import Then

final class OnBoardViewController: BaseViewController {
    
    private lazy var topGreetingLabel = UILabel()
    private lazy var logo = UIImageView()
    private lazy var bottomGreetingLabel = UILabel()
    private lazy var startButton = CSButton(.primary)
    
    
    override func attribute() {
        super.attribute()
        
        topGreetingLabel.do {
            $0.text = "날씨블리에 오신 걸\n환영해요!"
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 25)
        }
        
        logo.do {
            $0.image = UIImage(systemName: "star.fill")
        }
        
        bottomGreetingLabel.do {
            $0.text = "날씨블리가 날씨에 맞는\n옷차림을 알려드릴 거에요"
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 25)

            
        }
        
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        }
        
    }
    override func layout() {
    
        container.flex.alignItems(.center).define { flex in
            flex.addItem(topGreetingLabel)
            flex.addItem(logo).minHeight(201)
            flex.addItem(bottomGreetingLabel)
            flex.addItem(startButton).width(304).height(62)
        }
        
        topGreetingLabel.pin.top(view.pin.safeArea.top + 93).left(30).right(30)
        logo.pin.top(view.pin.safeArea.top + 224).left(126).right(126)
        bottomGreetingLabel.pin.top(view.pin.safeArea.top + 652).left(95).right(95)
        startButton.pin.top(view.pin.safeArea.top + 652).left(43).right(43)
    
//        .justifyContent(.spaceEvenly)
    }
    
    @objc private func didTapStartButton() {
        print(#function)
    }
}

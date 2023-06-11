//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit

final class OnBoardViewController: BaseViewController {
    
    private lazy var topGreetingLabel = UILabel().then {
        $0.text = "날씨블리에 오신 걸\n환영해요!"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 25)
    }
    
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
    }
    
    private lazy var bottomGreetingLabel = UILabel().then {
        $0.text = "날씨블리가 날씨에 맞는\n옷차림을 알려드릴 거에요"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 25)
    }
    
    private lazy var startButton = UIButton().then {
        $0.backgroundColor = .purple
        $0.setTitle("시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    override func configureLayout() {
        container.pin.all()
        container.flex.layout()
    }
    
    override func configureUI() {
        view.addSubview(container)
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(topGreetingLabel)
            flex.addItem(logo).size(100)
            flex.addItem(bottomGreetingLabel)
            flex.addItem(startButton).size(100)
        }
        .justifyContent(.spaceEvenly)
    }
    
    @objc private func didTapStartButton() {
        
    }
}

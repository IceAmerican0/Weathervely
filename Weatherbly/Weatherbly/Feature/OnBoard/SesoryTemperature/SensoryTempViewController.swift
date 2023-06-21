//
//  SensoryTempViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class SensoryTempViewController: BaseViewController {
    
    var progressBar = UIProgressView()
    var backButton = UIImageView()
    var mainMessageLabel = UILabel()
    
    
    var clothViewWrapper = UIView()
    
    var minTempWrapper = UIView()
    var minTempLabel = UILabel()
    var minTempImageView = UIImageView()
    var minImageSourceLabel = UILabel()
    
    var maxTempWrapper = UIView()
    var maxTempLabel = UILabel()
    var maxTempImageView = UIImageView()
    var maxImageSourceLabel = UILabel()
    
    var acceptButton = CSButton(.grayFilled)
    var denyButton = CSButton(.grayFilled)
    var confirmButton = CSButton(.primary)
    
    var notTodayLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func attribute() {
        super.attribute()
        
        progressBar.do {
            $0.progress = 1.0
            $0.progressViewStyle = .default
            $0.progressTintColor = CSColor._151_151_151.color
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        backButton.do {
            $0.image = AssetsImage.navigationBackButton.image
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        mainMessageLabel.do {
            // TODO: - 닉네임 변수 처리
            $0.text = "'어제'날씨의 추천 옷차림이에요\n(닉네임)님의 온도와 잘 맞나요?"
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        minTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        minTempLabel.do {
            $0.text = "최저 3 ℃"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        minImageSourceLabel.do {
            $0.text = "photo by 0000"
            $0.font = .boldSystemFont(ofSize: 11)
        }
        
        maxTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        maxTempLabel.do {
            $0.text = "최저 3 ℃"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        maxImageSourceLabel.do {
            $0.text = "photo by 0000"
            $0.font = .boldSystemFont(ofSize: 11)
        }
    }
    
    override func layout() {
        super.layout()
        
        
        clothViewWrapper.backgroundColor = .yellow
        container.flex.define { flex in
            flex.addItem(progressBar)
            flex.addItem(backButton).size(44).marginTop(15).left(12)
            flex.addItem(mainMessageLabel).marginTop(15)
            
            flex.addItem(clothViewWrapper).margin(42, 37, 0).direction(.row).define { flex in
                flex.addItem(minTempWrapper).grow(1).shrink(1).direction(.column).right(5).define { flex in
                    flex.addItem(minTempLabel).margin(9, 10, 0)
                    flex.addItem(minTempImageView).margin(10, 11, 0).height(295)
                    flex.addItem(minImageSourceLabel).margin(0, 28, 1)
                }
                flex.addItem(maxTempWrapper).grow(1).shrink(1).left(5).define { flex in
                    flex.addItem(maxTempLabel).margin(9, 10, 0)
                    flex.addItem(maxTempImageView).margin(10,11,0).height(295)
                    flex.addItem(maxImageSourceLabel).margin(0,28,1)
                }
            }
//
//            flex.addItem(acceptButton)
//            flex.addItem(denyButton)
//            flex.addItem(notTodayLabel)
        }
        
        setConstraint()
    }
    
    private func  setConstraint() {
        
//        progressBar.pin.top(view.pin.safeArea.top)
//        backButton.pin.top(to: progressBar.edge.bottom).marginTop(15).left(12)
//        mainMessageLabel.pin.top(to: backButton.edge.bottom).marginTop(15).left(30).right(30)
//        clothViewWrapper.backgroundColor = .yellow
//        clothViewWrapper.pin.top(to: mainMessageLabel.edge.bottom).marginTop(42).left(27).right(28).bottom( view.pin.safeArea.bottom).marginBottom(257)
//
//        setClothViewWrapperLayout()
////        topGreetingLabel.pin.top(view.pin.safeArea.top + 93).left(30).right(30)
////        logo.pin.top(to: topGreetingLabel.edge.bottom).marginTop(58).left(126).right(126)
////        bottomGreetingLabel.pin.top(to: logo.edge.bottom).marginTop(100).left(95).right(95)
////        startButton.pin.top(to: bottomGreetingLabel.edge.bottom).marginTop(69).left(43).right(43)

    }
    
    private func setClothViewWrapperLayout() {
        minTempWrapper.pin.topLeft(to: clothViewWrapper.anchor.topLeft).size(100)
        minTempWrapper.backgroundColor = .red
        maxTempWrapper.pin.after(of: minTempWrapper).margin(10).size(100)
        maxTempWrapper.backgroundColor = .blue
    }
    
}

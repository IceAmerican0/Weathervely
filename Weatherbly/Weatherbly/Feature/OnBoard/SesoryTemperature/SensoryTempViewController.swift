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
    
    var progressBar = CSProgressView(.bar)
    var backButton = UIImageView()
    var mainMessageLabel = CSLabel(.primary)
    
    
    var clothViewWrapper = UIView()
    
    var minTempWrapper = UIView()
    var minTempLabel = CSLabel(.primary)
    var minTempImageView = UIImageView()
    var minImageSourceLabel = CSLabel(.primary)
    
    var maxTempWrapper = UIView()
    var maxTempLabel = CSLabel(.primary)
    var maxTempImageView = UIImageView()
    var maxImageSourceLabel = CSLabel(.primary)
    
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
        }
        
        backButton.do {
            $0.image = AssetsImage.navigationBackButton.image
        }
        
        mainMessageLabel.do {
            // TODO: - 닉네임 변수 처리
            $0.text = "'어제'날씨의 추천 옷차림이에요\n(닉네임)님의 온도와 잘 맞나요?"
            $0.font = .boldSystemFont(ofSize: 24)
        }
        
        minTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        minTempLabel.do {
            $0.text = "최저 3℃"
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
            $0.text = "최고 3℃"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        maxImageSourceLabel.do {
            $0.text = "photo by 0000"
            $0.font = .boldSystemFont(ofSize: 11)
        }
        
        acceptButton.do {
            $0.setTitle("네", for: .normal)
        }
        
        denyButton.do {
            $0.setTitle("더 두껍게/얇게 입을게요", for: .normal)
        }
        
        notTodayLabel.do {
            $0.text = "그저께 옷차림으로 비교하기"
        }
    }
    
    override func layout() {
        super.layout()
        
        clothViewWrapper.backgroundColor = .yellow
        container.flex.define { flex in
            flex.addItem(progressBar)
            flex.addItem(backButton).marginTop(15).left(12).size(44)
            flex.addItem(mainMessageLabel).marginTop(15)
            
            flex.addItem(clothViewWrapper).direction(.row).marginTop(42).marginHorizontal(27).define { flex in
                flex.addItem(minTempWrapper).grow(1).shrink(1).marginRight(5).alignItems(.center).define { flex in
                    flex.addItem(minTempLabel).marginTop(9)
                    flex.addItem(minTempImageView).marginTop(10).height(295)
                    flex.addItem(minImageSourceLabel)
                }
                flex.addItem(maxTempWrapper).grow(1).shrink(1).marginLeft(5).alignItems(.center).define { flex in
                    flex.addItem(maxTempLabel).marginTop(9)
                    flex.addItem(maxTempImageView).marginTop(10).height(295)
                    flex.addItem(maxImageSourceLabel)
                }
            }
            
            flex.addItem(acceptButton).marginTop(30).marginHorizontal(20)
            flex.addItem(denyButton).marginTop(10).marginHorizontal(20)
            flex.addItem(notTodayLabel).alignSelf(.center).marginTop(20)
        }
    }
    
}

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
    var mainMessageLabel = CSLabel(.bold,
                                   labelText: "'어제'날씨의 추천 옷차림이에요\n(닉네임)님의 온도와 잘 맞나요?",
                                   labelFontSize: 24)
    
    var clothViewWrapper = UIView()
    
    var minTempWrapper = UIView()
    var minTempLabel = CSLabel(.regular)
    var minTempImageView = UIImageView()
    var minImageSourceLabel = CSLabel(.regular,
                                      labelText: "by 0000",
                                      labelFontSize: 11)
    
    var maxTempWrapper = UIView()
    var maxTempLabel = CSLabel(.regular)
    var maxTempImageView = UIImageView()
    var maxImageSourceLabel = CSLabel(.regular,
                                      labelText: "by 0000",
                                      labelFontSize: 11)
    
    var acceptButton = CSButton(.grayFilled)
    var denyButton = CSButton(.grayFilled)
    var confirmButton = CSButton(.primary)
    
    var notTodayLabel = CSLabel(.underline,
                                labelText: "그저께 옷차림으로 비교하기",
                                labelFontSize: 15)
    
    private let imageHeight = UIScreen.main.bounds.height * 0.34
    
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
        }
        
        minTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        minTempLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold(string: "오전 7시", fontSize: 18)
                .bold(string: "(최저 3℃)", fontSize: 16)
        }
        
        minTempImageView.do {
            $0.image = UIImage(systemName: "star.fill")
        }
        
        maxTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        maxTempLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold(string: "오후 2시", fontSize: 18)
                .bold(string: "(최고 3℃)", fontSize: 16)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }
        
        maxTempImageView.do {
            $0.image = UIImage(systemName: "star.fill")
        }
        
        acceptButton.do {
            $0.setTitle("네", for: .normal)
        }
        
        denyButton.do {
            $0.setTitle("더 두껍게/얇게 입을게요", for: .normal)
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
                    flex.addItem(minTempImageView).marginTop(10).width(70%).height(imageHeight)
                    flex.addItem(minImageSourceLabel).marginTop(6)
                }
                flex.addItem(maxTempWrapper).grow(1).shrink(1).marginLeft(5).alignItems(.center).define { flex in
                    flex.addItem(maxTempLabel).marginTop(9)
                    flex.addItem(maxTempImageView).marginTop(10).width(70%).height(imageHeight)
                    flex.addItem(maxImageSourceLabel).marginTop(6)
                }
            }
            
            flex.addItem(acceptButton).marginTop(39).marginHorizontal(43)
            flex.addItem(denyButton).marginTop(14).marginHorizontal(43)
            flex.addItem(notTodayLabel).alignSelf(.center).marginTop(24)
        }
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        
    }
    
}

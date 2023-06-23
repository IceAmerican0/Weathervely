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
            $0.font = .boldSystemFont(ofSize: 24)
        }
        
        minTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        minTempLabel.do {
            $0.text = "오전 7시 (최저 3℃)"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        minTempImageView.do {
            $0.backgroundColor = .black
        }
        
        minImageSourceLabel.do {
            $0.text = "by 0000"
            $0.font = .boldSystemFont(ofSize: 11)
        }
        
        maxTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .blue
            // TODO: - shadow처리
        }
    
        maxTempLabel.do {
            let timeString = NSAttributedString(string: "오후 2시")
            let tempString = NSAttributedString(string: "(최고 3℃)")
            $0.text = "오후 2시(최고 3℃)"
            $0.font = .boldSystemFont(ofSize: 18)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.8
        }
        
        maxTempImageView.do {
            $0.backgroundColor = .black
        }
        
        maxImageSourceLabel.do {
            $0.text = "by 0000"
            $0.font = .boldSystemFont(ofSize: 11)
        }
        
        acceptButton.do {
            $0.setTitle("네", for: .normal)
        }
        
        denyButton.do {
            $0.setTitle("더 두껍게/얇게 입을게요", for: .normal)
        }
        
        notTodayLabel.do {
            let attribute = NSMutableAttributedString(string: "그저께 옷차림으로 비교하기")
            attribute.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attribute.length))
            $0.attributedText = attribute
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
                    flex.addItem(minTempImageView).marginTop(10).height(imageHeight)
                    flex.addItem(minImageSourceLabel)
                }
                flex.addItem(maxTempWrapper).grow(1).shrink(1).marginLeft(5).alignItems(.center).define { flex in
                    flex.addItem(maxTempLabel).marginTop(9)
                    flex.addItem(maxTempImageView).marginTop(10).height(imageHeight)
                    flex.addItem(maxImageSourceLabel)
                }
            }
            
            flex.addItem(acceptButton).marginTop(39).marginHorizontal(43)
            flex.addItem(denyButton).marginTop(14).marginHorizontal(43)
            flex.addItem(notTodayLabel).alignSelf(.center).marginTop(24)
        }
    }
    
}

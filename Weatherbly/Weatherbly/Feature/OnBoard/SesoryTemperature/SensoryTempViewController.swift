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
        }
        
        backButton.do {
            $0.image = AssetsImage.navigationBackButton.image
        }
        
        mainMessageLabel.do {
            // TODO: - 닉네임 변수 처리
            $0.text = "'어제'날씨의 추천 옷차림이에요\n(닉네임)님의 온도와 잘 맞나요?"
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        minTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = .white
            // TODO: - shadow처리 
        }
    }
    
    override func layout() {
        super.layout()
    }
    
}

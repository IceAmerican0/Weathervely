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
    
    var headerWrapper = UIView()
    var progressBar = CSProgressView(.bar)
    var navigationBackButton = UIButton()
    
    var mainMessageLabel = CSLabel(.bold,
                                   labelText: "'어제'날씨의 추천 옷차림이에요\n(닉네임)님의 온도와 잘 맞나요?",
                                   labelFontSize: 22)
    
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
    
    var buttonWrapper = UIView()
    var acceptButton = CSButton(.grayFilled)
    var denyButton = CSButton(.grayFilled)
    var confirmButton = CSButton(.primary)
    
    var notTodayLabel = CSLabel(.underline,
                                labelText: "그저께 옷차림으로 비교하기",
                                labelFontSize: 15)
    
    private let imageHeight = UIScreen.main.bounds.height * 0.34
    private let buttonHeight = UIScreen.main.bounds.height * 0.054
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func attribute() {
        super.attribute()
        
        progressBar.do {
            $0.progress = 1.0
        }
        
        navigationBackButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
            $0.addTarget(self, action: #selector(didTapnavigationBackButton), for: .touchUpInside)
        }
        
        mainMessageLabel.do {
            // TODO: - 닉네임 변수 처리
            $0.text = "'어제'날씨의 추천 옷차림이에요\n(닉네임)님의\n온도와 잘 맞나요?"
            $0.adjustsFontSizeToFitWidth = true
            if UIScreen.main.bounds.width < 376 {
                $0.font = .boldSystemFont(ofSize: 18)
            }
        }
        
        minTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1)
            $0.layer.shadowRadius = 10
            // TODO: - shadow처리
        }
    
        minTempLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold(string: "오전 7시", fontSize: 18)
                .bold(string: "(최저 3℃)", fontSize: 16)
            $0.textColor = CSColor._40_106_167.color
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 1
        }
        
        minTempImageView.do {
            $0.backgroundColor = .blue
            $0.image = UIImage(systemName: "star.fill")
        }
        
        maxTempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1)
            $0.layer.shadowRadius = 10
            // TODO: - shadow처리
        }
    
        maxTempLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold(string: "오후 2시", fontSize: 18)
                .bold(string: "(최고 3℃)", fontSize: 16)
            $0.textColor = CSColor._178_36_36.color
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 1
        }
        
        maxTempImageView.do {
            $0.image = UIImage(systemName: "star.fill")
        }
        
        acceptButton.do {
            $0.setTitle("네", for: .normal)
            $0.backgroundColor = CSColor._50_50_50.color
        }
        
        denyButton.do {
            $0.setTitle("더 두껍게 / 얇게 입을게요", for: .normal)
            $0.backgroundColor = CSColor._50_50_50.color
            $0.addTarget(self, action: #selector(didTapDenyButton), for: .touchUpInside)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.justifyContent(.spaceBetween).define { flex in
            
            flex.addItem(headerWrapper).define { flex in
                flex.addItem(progressBar)
                flex.addItem(navigationBackButton).left(12).size(44).marginTop(15)
            }

                flex.addItem(mainMessageLabel).marginBottom(24).marginTop(10)

                flex.addItem(clothViewWrapper).direction(.row)
                    .marginHorizontal(27)
                    .define { flex in
                    flex.addItem(minTempWrapper)
                            .grow(1)
                            .shrink(1)
                            .marginRight(5)
                            .alignItems(.center)
                            .define { flex in
                        flex.addItem(minTempLabel).marginTop(11).marginHorizontal(20)
                        flex.addItem(minTempImageView).marginTop(10).width(70%).height(imageHeight)
                        flex.addItem(minImageSourceLabel).marginTop(7).marginBottom(7)
                    }

                    flex.addItem(maxTempWrapper)
                            .grow(1)
                            .shrink(1)
                            .marginLeft(5)
                            .alignItems(.center)
                            .define { flex in
                        flex.addItem(maxTempLabel).marginTop(11).marginHorizontal(20)
                        flex.addItem(maxTempImageView).marginTop(10).width(70%).height(imageHeight)
                        flex.addItem(maxImageSourceLabel).marginTop(7).marginBottom(7)
                    }
                }
            flex.addItem(buttonWrapper)
                .justifyContent(.center)
                .marginTop(39)
                .marginBottom(15)
                .define { flex in
                flex.addItem(acceptButton).marginHorizontal(43).height(buttonHeight)
                flex.addItem(denyButton).marginHorizontal(43).height(buttonHeight).marginTop(14)
                flex.addItem(notTodayLabel).marginTop(24)
            }
        }
    }
    
    @objc private func didTapnavigationBackButton(_ sender: UIButton) {
        print(#function)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDenyButton() {
        self.navigationController?.pushViewController(SlotMachineViewController(), animated: true)
    }
    
}

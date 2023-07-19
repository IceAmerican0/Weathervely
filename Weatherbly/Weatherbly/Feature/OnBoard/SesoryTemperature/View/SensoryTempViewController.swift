//
//  SensoryTempViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit
import FlexLayout
import PinLayout

final class SensoryTempViewController: RxBaseViewController<SensoryTempViewModel> {
    
    var headerWrapper = UIView()
    var progressBar = CSProgressView(1.0)
    var navigationBackButton = UIButton()
    
    var mainMessageLabel = CSLabel(.bold, 22, "(닉네임)님께도\n이 옷차림이 적당한가요?")
    
    var clothViewWrapper = UIView()
    
    var tempWrapper = UIView()
    var tempLabel = CSLabel(.bold, 18, "선택 시간 (3℃)")
    var tempImageView = UIImageView()
    var imageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    var discriptionLabel = CSLabel(.regular, 16 , "외출하셨을 때 날씨에\n추천되는 표준 옷차림이에요")
    
    var buttonWrapper = UIView()
    var acceptButton = CSButton(.primary)
    var denyButton = CSButton(.primary)
    
    var selectOtherDayLabel = CSLabel(.underline, 15, "다른 시간대 선택하기")
    
    private let imageHeight = UIScreen.main.bounds.height * 0.38
    private let buttonHeight = UIScreen.main.bounds.height * 0.054
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func attribute() {
        super.attribute()
        
        navigationBackButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
            $0.addTarget(self, action: #selector(didTapnavigationBackButton), for: .touchUpInside)
        }
        
        mainMessageLabel.do {
            // TODO: - 닉네임 변수 처리
            $0.text = "(닉네임)님께도\n이 옷차림이 적당한가요?"
            $0.adjustsFontSizeToFitWidth = true
            if UIScreen.main.bounds.width < 376 {
                $0.font = .boldSystemFont(ofSize: 18)
            }
        }
        
        clothViewWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
        }
        
        tempWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
            // TODO: - shadow처리
        }
    
        tempLabel.do {
            $0.setBackgroundColor(CSColor._172_107_255_004.color)
            $0.addBorders([.top, .left, .right, .bottom])
            $0.setCornerRadius(5)
            $0.attributedText = NSMutableAttributedString()
                .bold($0.text ?? "", 16, CSColor._40_106_167)
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 1
        }
        
        tempImageView.do {
            $0.image = AssetsImage.sampleCloth.image
        }
        
        discriptionLabel.do {
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 0
            $0.textColor = CSColor._102_102_102.color
            $0.setLineHeight(1.26)
        }
       
        acceptButton.do {
            $0.setTitle("네", for: .normal)
        }
        
        denyButton.do {
            $0.setTitle("아니오", for: .normal)
            $0.addTarget(self, action: #selector(didTapDenyButton), for: .touchUpInside)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex
//            .justifyContent(.spaceBetween)
            .define { flex in
            
            flex.addItem(headerWrapper).define { flex in
                flex.addItem(progressBar)
                flex.addItem(navigationBackButton).left(12).size(44).marginTop(15)
            }

            flex.addItem(mainMessageLabel).marginBottom(24)

            flex.addItem(clothViewWrapper)
                .justifyContent(.spaceAround)
                .paddingTop(24)
                .marginHorizontal(63)
                .grow(0.9)
                .shrink(0.9)
                .define { flex in
                    flex.addItem(tempLabel)
                        .marginHorizontal(50)
                        .paddingVertical(3)
                    flex.addItem(tempImageView)
                        .alignSelf(.center)
                        .marginTop(16)
                        .width(50%)
                        .height(78%)
                    flex.addItem(imageSourceLabel)
                        .marginTop(7)
                        .marginBottom(7)
                
            }
            
            flex.addItem(discriptionLabel)
                .alignSelf(.center)
                .margin(19)
            
            flex.addItem(buttonWrapper)
                .direction(.row)
                .justifyContent(.center)
                .marginHorizontal(54)
                .marginTop(19)
                .define { flex in
                    flex.addItem(acceptButton)
                        .grow(1)
                        .width(50%).height(buttonHeight)
                        .marginRight(12).paddingVertical(9)
                    flex.addItem(denyButton)
                        .grow(1)
                        .width(50%).height(buttonHeight)
                        .marginLeft(12).paddingVertical(9)
            }
            
                flex.addItem(selectOtherDayLabel).marginTop(27)
        }
    }
    
    override func viewBinding() {
     // TODO: - selectOtherDayLabel에 RxGesture 추가
    }
    
    @objc private func didTapnavigationBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDenyButton() {
        self.navigationController?.pushViewController(SlotMachineViewController(SlotMachineViewModel()), animated: true)
    }
    
}

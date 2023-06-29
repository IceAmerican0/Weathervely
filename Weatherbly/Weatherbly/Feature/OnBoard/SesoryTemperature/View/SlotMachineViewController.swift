//
//  SlotMachineViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/28.
//

import UIKit
import FlexLayout
import PinLayout

final class SlotMachineViewController: BaseViewController {
    
    // MARK: - Property

    var progressBar = CSProgressView(.bar)
    var navigationBackButton = UIButton()
    
    var mainLabel = CSLabel(.bold,
                            labelText: "'어제' (닉네임) 님에게\n적당했던 옷차림을 골라주세요",
                            labelFontSize: 22)
    var descriptionLabel = CSLabel(.regular,
                                   labelText: "사진을 위아래로 쓸어보세요\n다른 두께감의 옷차림이 나와요",
                                   labelFontSize: 20)
    
    var clothScrollViewWrapper = UIView()
    
    var leftScrollWrapper = UIView()
    var leftUpperArrowButton = UIButton()
    var leftDownArrowButton = UIButton()
    var minTempWrapper = UIView()
    var minTempLabel = CSLabel(.regular)
    var minTempImageView = UIImageView()
    var minImageSourceLabel = CSLabel(.regular,
                                      labelText: "by 0000",
                                      labelFontSize: 11)
    
    var rightScrollWrapper = UIView()
    var rightUpperArrowButton = UIButton()
    var rightDownArrowButton = UIButton()
    var maxTempWrapper = UIView()
    var maxTempLabel = CSLabel(.regular)
    var maxTempImageView = UIImageView()
    var maxImageSourceLabel = CSLabel(.regular,
                                      labelText: "by 0000",
                                      labelFontSize: 11)
    
    var confirmButton = CSButton(.primary)
    private let imageHeight = UIScreen.main.bounds.height * 0.34
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Function
    override func attribute() {
        super.attribute()
        
        progressBar.do {
            $0.progress = 1.0
        }
        
        navigationBackButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
            $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        }
        
        mainLabel.do {
            // TODO: - 닉네임 변수 처리
            $0.adjustsFontSizeToFitWidth = true
            if UIScreen.main.bounds.width < 376 {
                $0.font = .boldSystemFont(ofSize: 18)
            }
        }
        
        descriptionLabel.do {
                
            if UIScreen.main.bounds.width < 376 {
                $0.font = .boldSystemFont(ofSize: 16)
            }
        }
        
        leftUpperArrowButton.do {
            $0.setImage(AssetsImage.upArrow.image, for: .normal)
        }
        
        leftDownArrowButton.do {
            $0.setImage(AssetsImage.downArrow.image, for: .normal)
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
            $0.image = UIImage(systemName: "star.fill")
        }
        
        rightUpperArrowButton.do {
            $0.setImage(AssetsImage.upArrow.image, for: .normal)
        }
        
        rightDownArrowButton.do {
            $0.setImage(AssetsImage.downArrow.image, for: .normal)
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
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        }
        
        
       
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationBackButton)
                .size(44)
                .margin(15, 12, 0, 0)
            
            flex.addItem(mainLabel).marginTop(4).marginHorizontal(30)
            flex.addItem(descriptionLabel).marginTop(11).marginHorizontal(30)
            
            flex.addItem(clothScrollViewWrapper).direction(.row)
                .marginTop(16)
                .marginHorizontal(27)
                .define { flex in
                
                    // MARK: - leftSide View

                    flex.addItem(leftScrollWrapper)
                        .grow(1).shrink(1).marginRight(5)
                        .justifyContent(.spaceAround)
                        .define { flex in
                            flex.addItem(leftUpperArrowButton)
                                .size(44)
                                .alignSelf(.center)
                            
                            flex.addItem(minTempWrapper).alignItems(.center).define { flex in
                                flex.addItem(minTempLabel).marginTop(11).marginHorizontal(20)
                                flex.addItem(minTempImageView).marginTop(10).width(100%).height(imageHeight)
                                flex.addItem(minImageSourceLabel).marginBottom(7)
                            }
                            
                            flex.addItem(leftDownArrowButton)
                    }
                    
                    // MARK: - rightSide View

                    flex.addItem(rightScrollWrapper)
                        .grow(1).shrink(1).marginLeft(5)
                        .justifyContent(.spaceAround)
                        .define { flex in
                            
                            flex.addItem(rightUpperArrowButton)
                                .size(44)
                                .alignSelf(.center)
                            
                            flex.addItem(maxTempWrapper).alignItems(.center).define { flex in
                                flex.addItem(maxTempLabel).marginTop(11).marginHorizontal(20)
                                flex.addItem(maxTempImageView).marginTop(10).width(100%).height(imageHeight)
                                flex.addItem(maxImageSourceLabel).marginBottom(7)
                            }
                            
                            flex.addItem(rightDownArrowButton)
                    }
            }
            
            flex.addItem(confirmButton)
                .marginTop(40)
                .marginHorizontal(43)
                .height(62)
            
        }
    }
    
    override func bind() {
        super.bind()
    }
 
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

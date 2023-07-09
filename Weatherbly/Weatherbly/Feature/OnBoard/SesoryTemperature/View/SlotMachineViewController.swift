//
//  SlotMachineViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/28.
//

import UIKit
import FlexLayout
import PinLayout

final class SlotMachineViewController: BaseViewController, UIScrollViewDelegate {
    
    // MARK: - Property

    var images = [UIImage(systemName: "star.fill"), UIImage(systemName: "book.fill"), UIImage(systemName:"scribble"),
                  UIImage(systemName:"lasso")]

    var progressBar = CSProgressView(1.0)
    var navigationBackButton = UIButton()
    
    var mainLabel = CSLabel(.bold, 22, "'어제' (닉네임) 님에게\n적당했던 옷차림을 골라주세요")
    var descriptionLabel = CSLabel(.regular, 20, "사진을 위아래로 쓸어보세요\n다른 두께감의 옷차림이 나와요")
    
    var clothScrollViewWrapper = UIView()
    
    
    var leftScrollWrapper = UIView()
    var leftUpperArrowButton = UIButton()
    var leftDownArrowButton = UIButton()
    var minTempWrapper = UIView()
    var minTempLabel = CSLabel(.regular)
    var leftScrollView = UIScrollView()
    var minImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    var rightScrollWrapper = UIView()
    var rightUpperArrowButton = UIButton()
    var rightDownArrowButton = UIButton()
    var maxTempWrapper = UIView()
    var maxTempLabel = CSLabel(.regular)
    var rightScrollView = UIScrollView()
    var maxImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    var confirmButton = CSButton(.primary)
    private let imageHeight = UIScreen.main.bounds.height * 0.34
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        leftScrollView.delegate = self
        addContentLeftScrollView()
        addContentRightScrollView()
        
    }
    
    func addContentLeftScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let yPos = leftScrollView.frame.height * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: yPos, width: leftScrollView.bounds.width, height: leftScrollView.bounds.height)
            imageView.image = images[i]
            leftScrollView.addSubview(imageView)
            leftScrollView.contentSize.height = imageView.frame.height * CGFloat(i + 1)
        }
    }
    
    func addContentRightScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let yPos = rightScrollView.frame.height * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: yPos, width: rightScrollView.bounds.width, height: rightScrollView.bounds.height)
            imageView.image = images[i]
            rightScrollView.addSubview(imageView)
            rightScrollView.contentSize.height = imageView.frame.height * CGFloat(i + 1)
        }
    }

    // MARK: - Function
    override func attribute() {
        super.attribute()
        
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
        
        leftScrollView.do {
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
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
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
            // TODO: - shadow처리
        }
    
        minTempLabel.do {
            
            $0.attributedText = NSMutableAttributedString()
                .bold("오전 7시", 18)
                .bold("(최저 3℃)", 16)
            $0.textColor = CSColor._40_106_167.color
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 1
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
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
            // TODO: - shadow처리
        }
    
        maxTempLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold("오후 2시", 18)
                .bold("(최고 3℃)", 16)
            $0.textColor = CSColor._178_36_36.color
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 1
        }
        
        rightScrollView.do {
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
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
                                flex.addItem(leftScrollView).marginTop(10).width(70%).height(imageHeight)
                                flex.addItem(minImageSourceLabel).marginTop(7).marginBottom(7)
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
                                flex.addItem(rightScrollView).marginTop(10).width(70%).height(imageHeight)
                                flex.addItem(maxImageSourceLabel).marginTop(7).marginBottom(7)
                            }
                            
                            flex.addItem(rightDownArrowButton)
                    }
            }
            
            flex.addItem(confirmButton)
                .marginTop(23)
                .marginHorizontal(43)
                .height(confirmButton.primaryHeight)
            
            
        }
    }
    
    override func bind() {
        super.bind()
    }
 
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

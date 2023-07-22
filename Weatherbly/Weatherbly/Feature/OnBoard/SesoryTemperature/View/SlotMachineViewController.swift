//
//  SlotMachineViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/28.
//

import UIKit
import FlexLayout
import PinLayout

final class SlotMachineViewController: RxBaseViewController<SlotMachineViewModel>, UIScrollViewDelegate {
    
    // MARK: - Property

    private var images = [UIImage(systemName: "star.fill"), UIImage(systemName: "book.fill"), UIImage(systemName:"scribble"),
                  UIImage(systemName:"lasso")]

    private var headerView = UIView()
    private var progressBar = CSProgressView(1.0)
    private var navigationBackButton = UIButton()
    
    private var mainLabel = CSLabel(.bold, 22, "(닉네임) 님에게\n적당한 옷차림을 골라주세요")
    private var discriptionLabel = CSLabel(.regular, 16 , "사진을 위아래로 쓸어보세요\n다른 두께감의 옷차림이 나와요")
    
    private var clothScrollViewWrapper = UIView()
    
    private var upperArrowButton = UIButton()
    private var downArrowButton = UIButton()
    private var tempWrapper = UIView()
    private var tempLabel =  CSLabel(.bold, 18, "선택 시간 (3℃)")
    private var scrollView = UIScrollView()
    private var imageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private var bottomButton = CSButton(.primary)
    private let imageHeight = UIScreen.main.bounds.height * 0.38
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.delegate = self
        addContentscrollView()
    }
    
    func addContentscrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            let yPos = scrollView.frame.height * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: yPos, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = images[i]
            scrollView.addSubview(imageView)
            scrollView.contentSize.height = imageView.frame.height * CGFloat(i + 1)
        }
    }
    
    // TODO: - Toast message 띄우기
    
    // MARK: - Function
    override func attribute() {
        super.attribute()
        
        navigationBackButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
            $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        }
        
        mainLabel.do {
            $0.text = "(닉네임) 님에게\n적당한 옷차림을 골라주세요"
            $0.setLineHeight(1.07)
            
        }
        
        clothScrollViewWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
            // TODO: - shadow처리
        }
        
       
        scrollView.do {
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
        }
        
        upperArrowButton.do {
            $0.setImage(AssetsImage.upArrow.image, for: .normal)
        }
        
        tempLabel.do {
            $0.setBackgroundColor(CSColor._172_107_255_004.color)
            $0.addBorders([.top, .left, .right, .bottom])
            $0.setCornerRadius(5)
            $0.attributedText = NSMutableAttributedString()
                .bold($0.text ?? "", 16, CSColor._40_106_167)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        downArrowButton.do {
            $0.setImage(AssetsImage.downArrow.image, for: .normal)
        }
        
        discriptionLabel.do {
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 0
            $0.textColor = CSColor._102_102_102.color
            $0.setLineHeight(1.36)
        }
        
    
        bottomButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex
            .justifyContent(.spaceBetween)
            .paddingBottom(20)
            .define { flex in
            flex.addItem(headerView)
                .define { flex in
                    flex.addItem(progressBar)
                    flex.addItem(navigationBackButton)
                        .size(44)
                        .margin(15, 12, 0, 0)
            }
            
            flex.addItem(mainLabel)
                    .marginTop(-20)
            flex.addItem(clothScrollViewWrapper)
                .grow(1).shrink(1)
//                    .height(UIScreen.main.bounds.height * 0.52)
                .marginTop(20)
                .marginHorizontal(65)
                .paddingVertical(5)
                .justifyContent(.spaceAround)
                .define { flex in
                    flex.addItem(upperArrowButton).size(44).alignSelf(.center)
                    flex.addItem(tempLabel).marginTop(11)
                        .marginHorizontal(50)
                        .paddingVertical(3)
                    flex.addItem(scrollView)
                        .marginTop(13)
                        .width(50%)
                        .height(UIScreen.main.bounds.height * 0.37)
//                        .height(73%)
                        .alignSelf(.center)
                    flex.addItem(imageSourceLabel)
                        .marginTop(12)
                    flex.addItem(downArrowButton).size(44).marginTop(9).alignSelf(.center)
                }
            flex.addItem(discriptionLabel)
                .marginTop(15)
            flex.addItem(bottomButton)
                .marginTop(16)
                .marginHorizontal(43)
                .height(bottomButton.primaryHeight)
            
            
        }
        
        
    }
    
    override func bind() {
        super.bind()
    }
 
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

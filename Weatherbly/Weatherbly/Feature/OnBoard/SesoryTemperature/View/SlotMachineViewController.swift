//
//  SlotMachineViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/28.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import Kingfisher

final class SlotMachineViewController: RxBaseViewController<SlotMachineViewModel> {
    
    // MARK: - Property
    private var headerView = UIView()
    private var progressBar = CSProgressView(1)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    
    private var mainLabel = CSLabel(.bold, 22, "\(UserDefaultManager.shared.nickname)님에게\n적당한 옷차림을 골라주세요")
    private var discriptionLabel = CSLabel(.regular, 16 , "사진을 위아래로 쓸어보세요\n다른 두께감의 옷차림이 나와요")
    
    private var clothScrollViewWrapper = UIView()
    
    private var upperArrowButton = UIButton()
    private var downArrowButton = UIButton()
    private var tempWrapper = UIView()
    private var tempLabel =  CSLabel(.bold, 18, "선택 시간 (3℃)")
    private var scrollView = UIScrollView()
    private var imageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private var bottomButton = CSButton(.primary)
    private var firstAppear = true
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tempLabel.attributedText = NSMutableAttributedString()
            .bold("\(viewModel.labelStringRelay.value)시 (\(viewModel.temperatureRelay.value)℃)", 16, CSColor._172_107_255)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.delegate = self
        
        // TODO: init에서 받아온 list subscribe시 스크롤뷰 안뜨는 현상 수정
        if firstAppear == true {
            addContentscrollView()
            firstAppear = false
        }
    }
    
    func addContentscrollView() {
        guard let list = viewModel.closetListRelay.value else { return }
        for i in 0..<list.count {
            let imageView = UIImageView()
            let yPos = scrollView.frame.height * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: yPos, width: scrollView.bounds.width, height: scrollView.bounds.height)
            if let url = URL(string: list[i].imageUrl) {
                imageView.kf.setImage(with: url,
                                                placeholder: nil,
                                                options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(2))),
                                                          .transition(.fade(0.1)),
                                                          .cacheOriginalImage]) { result in
                    switch result {
                    case .success:
                        break
                    case .failure:
                        break
                    }
                }
            }
            scrollView.addSubview(imageView)
            scrollView.contentSize.height = imageView.frame.height * CGFloat(i + 1)
        }
        
        let middlePageIndex = Int((Double(list.count) / 2.0).rounded()) - 1
        let middleContentOffset = CGPoint(x: 0, y: scrollView.frame.height * CGFloat(middlePageIndex))
        scrollView.setContentOffset(middleContentOffset, animated: false)
        imageSourceLabel.text = "by \(list[middlePageIndex-1].shopName)"
    }
    
    // MARK: - Attribute
    override func attribute() {
        super.attribute()
        
        mainLabel.do {
            $0.setLineHeight(1.07)
        }
        
        clothScrollViewWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
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
            $0.attributedText = NSMutableAttributedString()
                .regular("사진을 " , 16, CSColor._102_102_102)
                .bold("위", 17, CSColor._102_102_102)
                .regular("로 밀면 옷이 더 " , 16, CSColor._102_102_102)
                .bold("두꺼워져요\n", 17, CSColor._102_102_102)
                .regular("사진을 " , 16, CSColor._102_102_102)
                .bold("아래", 17, CSColor._102_102_102)
                .regular("로 밀면 옷이 더 " , 16, CSColor._102_102_102)
                .bold("얇아져요", 17, CSColor._102_102_102)
        }
        
        bottomButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: - Layout

    override func layout() {
        super.layout()
        
        container.flex
            .justifyContent(.spaceBetween)
            .paddingBottom(20)
            .define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            
            flex.addItem(mainLabel)
                    .marginTop(-20)
            flex.addItem(clothScrollViewWrapper)
                .grow(1).shrink(1)
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
    
    // MARK: - Bind
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        bottomButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapAcceptButton()
            })
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.closetListRelay
            .subscribe(onNext: { [weak self] _ in
                self?.addContentscrollView()
            })
            .disposed(by: bag)
    }
    
}

extension SlotMachineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)
        
        guard let list = viewModel.closetListRelay.value else { return }
        if pageIndex >= 0 && pageIndex < list.count {
            viewModel.closetIDRelay.accept(list[pageIndex].closetId)
            imageSourceLabel.text = "by \(list[pageIndex].shopName)"
        }
        
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let contentOffsetY = scrollView.contentOffset.y
        
        // 스크롤뷰의 맨 위에 도달했을 때
        if contentOffsetY < 0 {
            viewModel.alertMessageRelay.accept(.init(title: "이게 가장 두꺼운 옷차림이에요",
                                                     alertType: .Info))
            let middleContentOffset = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(middleContentOffset, animated: false)
            imageSourceLabel.text = "by \(list[0].shopName)"
        }
        
        // 스크롤뷰의 맨 아래에 도달했을 때
        if contentOffsetY + scrollViewHeight > contentHeight {
            viewModel.alertMessageRelay.accept(.init(title: "이게 가장 얇은 옷차림이에요",
                                                     alertType: .Info))
            let middleContentOffset = CGPoint(x: 0, y: scrollView.frame.height * CGFloat(list.count - 1))
            scrollView.setContentOffset(middleContentOffset, animated: false)
            imageSourceLabel.text = "by \(list[list.count-1].shopName)"
        }
    }
}

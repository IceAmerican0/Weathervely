//
//  HomeSensoryTempViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/07.
//

import UIKit
import FlexLayout
import PinLayout
import Kingfisher



class HomeSensoryTempViewController: RxBaseViewController<HomeSensoryTempViewModel>, UIScrollViewDelegate{
    
    // MARK: - Property
    var images = [UIImage(systemName: "star.fill"), UIImage(systemName: "book.fill"), UIImage(systemName:"scribble"),
                  UIImage(systemName:"lasso")]

    private var headerView = UIView()
    private var navigationDismissButton = UIButton()
    
    private var mainLabel = CSLabel(.bold, 20, "")
    private var discriptionLabel = CSLabel(.regular, 16 , "사진을 위로 밀면 옷이 더 두꺼워져요\n사진을 아래로 밀면 옷이 더 얇아져요")
    
    private var clothScrollViewWrapper = UIView()
    
    private var upperArrowButton = UIButton()
    private var downArrowButton = UIButton()
    private var tempWrapper = UIView()
    private var tempLabel =  CSLabel(.bold, 18, "선택 시간 (3℃)")
    private var scrollView = UIScrollView()
    private var imageSourceLabel = CSLabel(.regular, 11, "loading")
    
    private var bottomButton = CSButton(.primary)
    private let imageHeight = UIScreen.main.bounds.height * 0.38
    
    func addContentscrollView() {
        guard let closetsList = viewModel.closetListByTempRelay.value else { return }
        
        for i in 0..<closetsList.count {
            let yPos = scrollView.frame.height * CGFloat(i)
            let imageView = UIImageView()
            imageView.frame = CGRect(x: scrollView.bounds.width * 0.25, y: yPos, width: scrollView.bounds.width / 2, height: scrollView.bounds.height)
            
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.startAnimating()
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = CGPoint(x: imageView.bounds.width / 2 ,y: imageView.bounds.height / 2)
            
            let imageUrl = closetsList[i].imageUrl
                if let url = URL(string: imageUrl) {
                    imageView.kf.setImage(with: url,
                                          placeholder: nil,
                                          options: [
                                            .retryStrategy(
                                                DelayRetryStrategy(maxRetryCount: 2,
                                                                   retryInterval: .seconds(2))),
                                            .transition(.fade(0.1)),
                                            .cacheOriginalImage]) { result in
                        switch result {
                        case .success:
                            indicator.stopAnimating()
                            indicator.isHidden = true
                            self.imageSourceLabel.attributedText = NSMutableAttributedString().regular("by \(closetsList[i].shopName)", 11, .none)
                        case .failure:
                            indicator.stopAnimating()
                            indicator.isHidden = true
                            imageView.image = AssetsImage.defaultImage.image
                            self.imageSourceLabel.text = ""
                        }
                    }
                }
            
            scrollView.addSubview(imageView)
            scrollView.addSubview(indicator)
            scrollView.contentSize.height = imageView.frame.height * CGFloat(i + 1)
        }
    }
    
    // MARK: - Attribute
    override func attribute() {
        super.attribute()
        
        navigationDismissButton.do {
            $0.setImage(AssetsImage.closeButton.image, for: .normal)
        }
        
        mainLabel.do {
            $0.setLineHeight(1.07)
            $0.attributedText = NSMutableAttributedString().bold("\(UserDefaultManager.shared.nickname) 님에게\n적당한 옷차림을 골라주세요", 20, .none)
        }
        
        clothScrollViewWrapper.do {
            $0.layer.cornerRadius = 20.0
            $0.backgroundColor = CSColor._253_253_253.color
            $0.setShadow(CGSize(width: 0, height: 4), CSColor._220_220_220.cgColor, 1, 10)
        }
        
        scrollView.do {
            $0.delegate = self
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
        }
        
        upperArrowButton.do {
            $0.setImage(AssetsImage.upArrow.image, for: .normal)
        }
        
        tempLabel.do {
            $0.setBackgroundColor(CSColor._172_107_255_004.color)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CSColor._217_217_217.cgColor
            $0.setCornerRadius(3)
            $0.attributedText = NSMutableAttributedString()
                .bold($0.text ?? "", 16, CSColor._172_107_255)
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
            flex.addItem(headerView)
                .define { flex in
                    flex.addItem(navigationDismissButton)
                        .size(44)
                        .margin(15, 12, 0, 0)
            }
            
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
                        .width(100%)
                        .height(UIScreen.main.bounds.height * 0.37)
                        .alignSelf(.center)
                    flex.addItem(imageSourceLabel)
                        .minHeight(13)  // se, mini 와 같은 디바이스에서 라벨 최소높이 강제
                        .marginTop(15)
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
        
        navigationDismissButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: bag)
        
        upperArrowButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.moveUp()
            }
            .disposed(by: bag)
        
        downArrowButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.moveDown()
            }
            .disposed(by: bag)
        
        bottomButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.setSensoryTemperature()
            }
            .disposed(by: bag)
    }
    
    private func moveUp() {
        guard let list = viewModel.closetListByTempRelay.value else { return }
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.height) - 1
        
        if pageIndex >= 0 && pageIndex < list.count {
            let yOffset = CGFloat(pageIndex) * scrollView.bounds.height
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            viewModel.setClosetIdRelay.accept(list[pageIndex].closetId)
            imageSourceLabel.attributedText = NSMutableAttributedString().regular("by \(list[pageIndex].shopName)", 11, .none)
            
        } else {
            viewModel.alertState.accept(.init(title: "이게 가장 얇은 옷차림이에요",
                                                     alertType: .toast))
        }
    }
    
    private func moveDown() {
        guard let list = viewModel.closetListByTempRelay.value else { return }
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.height) + 1
        
        if pageIndex >= 0 && pageIndex < list.count {
            let yOffset = CGFloat(pageIndex) * scrollView.bounds.height
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            viewModel.setClosetIdRelay.accept(list[pageIndex].closetId)
            imageSourceLabel.attributedText = NSMutableAttributedString().regular("by \(list[pageIndex].shopName)", 11, .none)
        } else {
            viewModel.alertState.accept(.init(title: "이게 가장 두꺼운 옷차림이에요",
                                                     alertType: .toast))
        }
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.closetListByTempRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    owner.addContentscrollView()
                    owner.scrollView.setContentOffset(CGPoint(x: 0, y: owner.viewModel.focusingIndexRelay.value), animated: true)
            })
            .disposed(by: bag)
        
        viewModel.slotMachineIndexRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, index in
                    owner.viewModel.yOffsetForIndex(index, owner.scrollView)
            })
            .disposed(by: bag)

        viewModel.selectedTimeRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, text in
                    guard var selectedTime = text,
                          let selectedTemp = owner.viewModel.selectedTempRelay.value
                    else { return }
                    
                    if selectedTime == Date().todayThousandFormat { selectedTime = "현재"}
                    owner.tempLabel.attributedText = NSMutableAttributedString()
                        .bold("\(selectedTime) (\(selectedTemp))", 16, CSColor._40_106_167)
            }).disposed(by: bag)
        
        viewModel.getClosetBySensoryTemp()
    }
}

extension HomeSensoryTempViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let list = viewModel.closetListByTempRelay.value else { return }
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)
        
        if pageIndex >= 0 && pageIndex < list.count {
            viewModel.setClosetIdRelay.accept(list[pageIndex].closetId)
            imageSourceLabel.attributedText = NSMutableAttributedString().regular("by \(list[pageIndex].shopName)", 11, .none)
        }
        
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let contentOffsetY = scrollView.contentOffset.y
        
        // 스크롤뷰의 맨 위에 도달했을 때
        if contentOffsetY < 0 {
            viewModel.alertState.accept(.init(title: "이게 가장 얇은 옷차림이에요",
                                                     alertType: .toast))
            let middleContentOffset = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(middleContentOffset, animated: false)
            imageSourceLabel.attributedText = NSMutableAttributedString().regular("by \(list[pageIndex].shopName)", 11, .none)
        }
        
        // 스크롤뷰의 맨 아래에 도달했을 때
        if contentOffsetY + scrollViewHeight > contentHeight {
            viewModel.alertState.accept(.init(title: "이게 가장 두꺼운 옷차림이에요",
                                                     alertType: .toast))
            let middleContentOffset = CGPoint(x: 0, y: scrollView.frame.height * CGFloat(list.count - 1))
            scrollView.setContentOffset(middleContentOffset, animated: false)
            imageSourceLabel.attributedText = NSMutableAttributedString().regular( "by \(list[list.count-1].shopName)", 11, .none)
           
        }
    }
}

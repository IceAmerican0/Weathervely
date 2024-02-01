//
//  OnBoardSensoryTempViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxGesture
import Kingfisher
import Then

final class OnBoardSensoryTempViewController: RxBaseViewController<OnBoardSensoryTempViewModel> {
    
    private var progressBar = CSProgressView(1.0)
    private var navigationBackButton = CSNavigationView(.leftButton(.navi_back))
    
    private var mainMessageLabel = CSLabel(.bold, 22, "")
    
    private var clothViewWrapper = UIView()
    
    private var tempWrapper = UIView()
    private var tempLabel = UILabel()
    private var tempImageView = UIImageView()
    private var imageSourceLabel = CSLabel(.regular, 11, "loading...")
    
    private var indicator = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
    
    private var discriptionLabel = CSLabel(.regular, 16 , "외출하셨을 때 날씨에\n추천되는 표준 옷차림이에요")
    
    private var buttonWrapper = UIView()
    private var acceptButton = CSButton(.primary)
    private var denyButton = CSButton(.primary)
    
    private var selectOtherDayLabel = CSLabel(.underline, 18, "다른 시간대 선택하기")
    
    private let imageHeight = UIScreen.main.bounds.height * 0.38
    private let buttonHeight = UIScreen.main.bounds.height * 0.054
    
    override func attribute() {
        super.attribute()
        
        mainMessageLabel.do {
            $0.setLineHeight(1.07)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.attributedText = NSMutableAttributedString()
                .bold("\(UserDefaultManager.shared.nickname)님께도\n이 옷차림이 적당한가요?", 22, CSColor.none)
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
        }
    
        tempLabel.do {
            $0.setBackgroundColor(CSColor._172_107_255_004.color)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CSColor._217_217_217.cgColor
            $0.setCornerRadius(3)
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 1
        }
        
        discriptionLabel.do {
            $0.setLineHeight(1.26)
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 0
            $0.textColor = CSColor._102_102_102.color
        }
       
        acceptButton.do {
            $0.setTitle("네", for: .normal)
        }
        
        denyButton.do {
            $0.setTitle("아니요", for: .normal)
        }
        
        selectOtherDayLabel.do {
            $0.isUserInteractionEnabled = true
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex
            .paddingBottom(20)
            .define { flex in
            
            flex.addItem(progressBar)
            flex.addItem(navigationBackButton).width(100%)

            flex.addItem(mainMessageLabel)
                    .marginTop(-20)
                    .marginBottom(24)
                
            flex.addItem(clothViewWrapper)
                .justifyContent(.spaceAround)
                .paddingTop(24)
                .marginHorizontal(63)
                .grow(1)
                .shrink(1)
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
                        .height(13)
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
            flex.addItem(indicator)
        }
        
        indicator.pin.hCenter(to: tempImageView.edge.hCenter).vCenter(to: tempImageView.edge.vCenter)
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationBackButton.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        denyButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.toSlotMachineView()
            }
            .disposed(by: bag)
        
        acceptButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapAcceptButton()
            }
            .disposed(by: bag)
        
        selectOtherDayLabel.rx.tapGesture().when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.getInfo()
        
        viewModel.closetListRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, data in
                    let temperature = owner.viewModel.temperatureRelay.value
                    guard let closets = data else { return }
                    
                    for i in 0..<closets.count {
                        if temperature >= closets[i].minTemp && temperature < closets[i].maxTemp {
                            if let url = URL(string: closets[i].imageUrl) {
                                owner.tempImageView.kf.setImage(with: url,
                                                                placeholder: nil,
                                                                options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(2))),
                                                                          .transition(.fade(0.1)),
                                                                          .cacheOriginalImage]) { result in
                                    switch result {
                                    case .success:
                                        owner.indicator.stopAnimating()
                                        owner.indicator.isHidden = true
                                        owner.imageSourceLabel.attributedText = NSMutableAttributedString().regular("by \(closets[i].shopName)", 11, CSColor.none)
                                        owner.viewModel.closetIDRelay.accept(closets[i].closetId)
                                    case .failure:
                                        owner.indicator.stopAnimating()
                                        owner.indicator.isHidden = true
                                        owner.tempImageView.image = AssetsImage.defaultImage.image
                                        owner.imageSourceLabel.text = ""
                                    }
                                }
                            }
                        }
                    }
            })
            .disposed(by: bag)
        
        viewModel.temperatureRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, temp in
                    let time = owner.viewModel.dateStringRelay.value
                    owner.tempLabel.attributedText = NSMutableAttributedString()
                        .bold("\(time)시 (\(temp)℃)", 16, CSColor._172_107_255)
            })
            .disposed(by: bag)
    }
}

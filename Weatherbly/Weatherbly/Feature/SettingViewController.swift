//
//  SettingViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/04.
//

import UIKit
import FlexLayout
import RxCocoa
import RxSwift

final class SettingViewController: RxBaseViewController<SettingViewModel> {
    
    var leftButtonDidTapRelay = PublishRelay<Void>()
    
    // MARK: - Component
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private let contentWrapper = UIView()
    private var nickNameView = UIView()
    private var nickNameLabel = CSLabel(.bold, 18, "(닉네임)님")
    private var editButton = UIButton()
    
    private var messageView = UIView()
    private var stickerIcon = UIImageView()
    private var messageLabel = CSLabel(.regular, 16, "오늘 하루는 어떠셨나요?\n지치고 힘든 하루를 잘 견뎌낸 나에게\n\"잘했다\"한 마디는 어떨까요?")
    
    private var firstButtonWrapper = UIView()
    private var sensoryTempButton = UIButton()
    private var styleButton = UIButton()
    private let secondButtonWrapper = UIView()
    private var locationButton = UIButton()
    private var inquryButton = UIButton()
    
    private var bottomView = UIView()
    private var bottomLabel = CSLabel(.regular,12,"개인정보 처리 방침 및 정보 제공처")
    
    private let bottomLabelTapGesture = UITapGestureRecognizer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nickNameLabel.text = "\(UserDefaultManager.shared.nickname)님"
    }

    // MARK: - Attiribute
    override func attribute() {
        super.attribute()
        
        navigationView.do {
            $0.setTitle("설정")
            $0.addBorder(.bottom)
        }
        
        nickNameView.do {
            $0.addBorder(.top)
            $0.addBorder(.bottom)
        }
        
        nickNameLabel.do {
            $0.adjustsFontSizeToFitWidth = true
        }
        
        editButton.do {
            $0.setImage(AssetsImage.editNameIcon.image, for: .normal)
        }
        
        stickerIcon.do {
            $0.image = AssetsImage.whiteHeart.image
        }
        
        messageView.do {
            $0.addBorder(.bottom)
        }
        
        messageLabel.do {
            $0.textAlignment = .natural
            $0.adjustsFontSizeToFitWidth = true
        }
        
        sensoryTempButton.do {
            $0.setShadow(CGSize(width: 0, height: 3), UIColor.black.cgColor, 0.25, 2)
            $0.setTitle("체감 온도", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.setImage(AssetsImage.settingTemperatureIcon.image, for: .normal)
            $0.alignTextBelowImage()
            $0.setCornerRadius(24)
        }
        
        styleButton.do {
            /// 기본 shoadowColor는 _0__03 컬러를 사용하나, 여기서는 배경때문에 잘 보이지 않아서
            /// 더 명확하게 보이기위해서 black 컬러사용
            $0.setShadow(CGSize(width: 0, height: 3), UIColor.black.cgColor, 0.25,  2)
            $0.setTitle("스타일 선택", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.setImage(AssetsImage.settingStyleIcon.image, for: .normal)
            $0.alignTextBelowImage()
            $0.setCornerRadius(24)
        }
        
        locationButton.do {
            $0.setShadow(CGSize(width: 0, height: 3), UIColor.black.cgColor, 0.25, 2)
            $0.setTitle("동네 설정", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.setImage(AssetsImage.settingLocationIcon.image, for: .normal)
            $0.alignTextBelowImage()
            $0.setCornerRadius(24)
            
        }
        
        inquryButton.do {
            $0.setShadow(CGSize(width: 0, height: 3), UIColor.black.cgColor, 0.25, 2)
            $0.setTitle("문의하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.setImage(AssetsImage.settingInquryIcon.image, for: .normal)
            $0.alignTextBelowImage()
            $0.setCornerRadius(24)
        }
        
        bottomLabel.do {
            $0.addGestureRecognizer(bottomLabelTapGesture)
        }
        
        bottomView.do {
            $0.addBorder(.top)
        }
    }

    // MARK: - Layout
    
    override func layout() {
        super.layout()
        container.flex
            .direction(.column)
            .justifyContent(.spaceBetween)
            .define { flex in
            flex.addItem(navigationView)
                    
            
            flex.addItem(contentWrapper)
                    .grow(1)
                    .shrink(1)
                .define { flex in

                    flex.addItem(nickNameView)
                        .direction(.row)
                        .marginTop(27)
                        .marginHorizontal(32)
                        .define { flex in

                        flex.addItem(nickNameLabel)
                            .marginVertical(9)
                            .marginLeft(60)
                        flex.addItem(editButton)
                                .marginTop(5)
                                .marginLeft(6)
                                .size(24)
                    }
                    
                    flex.addItem(messageView)
                        .marginHorizontal(32)
                        .direction(.row)
                        .define { flex in
                            flex.addItem(stickerIcon)
                                .size(32)
                                .margin(18, 13, 35, 15)
                            flex.addItem(messageLabel)
                                .marginVertical(11)
                        }

                    flex.addItem(firstButtonWrapper)
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .marginTop(40)
                        .marginHorizontal(40)
                        .define { flex in
                            flex.addItem(sensoryTempButton)
                                .width(UIScreen.main.bounds.width * 0.37)
                                .height(UIScreen.main.bounds.height * 0.17)
                                .marginRight(10)

                            flex.addItem(styleButton)
                                .width(UIScreen.main.bounds.width * 0.37)
                                .height(UIScreen.main.bounds.height * 0.17)
                                .marginLeft(10)
                        }

                    flex.addItem(secondButtonWrapper)
                        .direction(.row)
                        .justifyContent(.spaceBetween)
                        .marginTop(21)
                        .marginHorizontal(40)
                        .define { flex in
                            flex.addItem(locationButton)
                                .width(UIScreen.main.bounds.width * 0.37)
                                .height(UIScreen.main.bounds.height * 0.17)
                                .marginRight(10)

                            flex.addItem(inquryButton)
                                .width(UIScreen.main.bounds.width * 0.37)
                                .height(UIScreen.main.bounds.height * 0.17)
                                .marginLeft(10)
                        }
                    
                    flex.addItem(bottomView)
                        
                        .padding(12)
                        .define { flex in
                            flex.addItem(bottomLabel)
                        }
                    bottomView.pin.bottom(to: contentWrapper.edge.bottom).marginBottom(5)
                    
                        
            }
        }
        
    }
    
    override func bind() {
        super.bind()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        editButton.rx.tap
            .bind(onNext: viewModel.toEditNicknameView)
            .disposed(by: bag)
        
        locationButton.rx.tap
            .bind(onNext: viewModel.toEditRegionView)
            .disposed(by: bag)
        
        styleButton.rx.tap
            .bind(onNext: viewModel.toBeContinue)
            .disposed(by: bag)
        
        inquryButton.rx.tap
            .bind(onNext: viewModel.toBeContinue)
            .disposed(by: bag)
        
        bottomLabelTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.toBeContinue()
            })
            .disposed(by: bag)
    }

}

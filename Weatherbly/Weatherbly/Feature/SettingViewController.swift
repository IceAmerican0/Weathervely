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
    
    private var buttonInnerView = UIView()
    private var buttonInnerImageView = UIImageView(image: AssetsImage.settingLocationIcon.image)
    
    private var locationButton = UIButton()
    
    private var bottomView = UIView()
    private var bottomLabel = CSLabel(.regular,12,"개인정보 처리 방침 및 정보 제공처")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nickNameLabel.attributedText = NSMutableAttributedString().bold("\(UserDefaultManager.shared.nickname)님", 18, CSColor.none)
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
            $0.textAlignment = .left
            $0.numberOfLines = 0
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
            $0.attributedText = NSMutableAttributedString().regular("오늘 하루는 어떠셨나요?\n지치고 힘든 하루를 잘 견뎌낸 나에게\n\"잘했다\"한 마디는 어떨까요?", 16, CSColor.none)
            
        }
        
        
        locationButton.do {
            $0.setShadow(CGSize(width: 0, height: 3), UIColor.black.cgColor, 0.25, 2)
//            $0.setTitle("체감 온도", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(r: 254, g: 254, b: 254)
            $0.setCornerRadius(24)
        }
        
        bottomLabel.do {
            $0.isUserInteractionEnabled = true
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
                        .marginTop(40)
                        .marginHorizontal(32)
                        .define { flex in
                            flex.addItem(locationButton)
                                .height(113)
                                .direction(.row)
                                .define { flex in
                                    flex.addItem(buttonInnerView)
                                        .marginLeft(34)
                                        .define { flex in
                                            
                                        var title = UILabel()
                                        var subTitle = UILabel()
                                        title.attributedText = NSMutableAttributedString().bold("동네설정", 18, CSColor._128_128_128)
                                        subTitle.attributedText = NSMutableAttributedString().regular("즐겨찾기 추가/변경", 20, CSColor.none)
                                            
                                        flex.addItem(title).marginTop(22)
                                        flex.addItem(subTitle).marginTop(15)
                                    }
                                    
                                    flex.addItem(buttonInnerImageView).width(56).height(60).marginVertical(26.5)
                                    buttonInnerImageView.pin.right(36)
                                    
                                }
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
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.navigationPoptoRootRelay.accept(Void())
            })
            .disposed(by: bag)
        
        editButton.rx.tap
            .bind(onNext: viewModel.toEditNicknameView)
            .disposed(by: bag)
        
        locationButton.rx.tap
            .bind(onNext: viewModel.toEditRegionView)
            .disposed(by: bag)
        
        bottomLabel.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.toPrivacyPolicyView()
            })
            .disposed(by: bag)
    }

}

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
import RxGesture

final class SettingViewController: RxBaseViewController<SettingViewModel> {
    
    // MARK: - Component
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private let contentWrapper = UIView()
    private var nickNameView = UIView()
    private var nickNameLabel = CSLabel(.bold, 18, "님")
    private var editButton = UIButton()
    
    private var messageView = UIView()
    private var stickerIcon = UIImageView()
    private var messageLabel = CSLabel(.regular, 16, "")
    
    private var firstButtonWrapper = UIView()
    
    private var buttonInnerView = UIView()
    private var buttonInnerImageView = UIImageView(image: AssetsImage.settingLocationIcon.image)
    
    private var locationButton = UIButton()
    private var locationTitleLabel = UILabel()
    private var locationSubtitleLabel = UILabel()
    
    private var bottomView = UIView()
    private var bottomLabel = CSLabel(.regular, 12, "개인정보 처리 방침 및 정보 제공처")
    
    private let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setRxButtonBinding()
    }

    // MARK: - Attiribute
    override func attribute() {
        super.attribute()
        
        navigationView.do {
            $0.setTitle("설정")
            $0.addBorder(.bottom)
            $0.backgroundColor = CSColor._253_253_253.color
        }
        
        nickNameView.do {
            $0.addBorder(.top)
            $0.addBorder(.bottom)
            $0.addGestureRecognizer(tapGesture)
        }
        
        nickNameLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 0
            nickNameLabel.attributedText = NSMutableAttributedString().bold("\(UserDefaultManager.shared.nickname)님", 18, CSColor.none)
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
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setBackgroundColor(CSColor._245_245_245.color)
            $0.setCornerRadius(24)
        }
        
        buttonInnerView.do {
            $0.isUserInteractionEnabled = false
        }
        
        locationTitleLabel.do {
            $0.attributedText = NSMutableAttributedString().bold("동네 설정", 18, CSColor._128_128_128)
            $0.isUserInteractionEnabled = false
        }
        
        locationSubtitleLabel.do {
            $0.attributedText = NSMutableAttributedString().medium("즐겨찾기 추가 / 변경", 20, CSColor.none)
            $0.isUserInteractionEnabled = false
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
                                            flex.addItem(locationTitleLabel).marginTop(22)
                                            flex.addItem(locationSubtitleLabel).marginTop(15)
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
                if let viewControllers = self?.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let homeViewController = viewController as? HomeViewController {
                            self?.navigationController?.popToViewController(homeViewController, animated: true)
                            break
                        }
                    }
                }
            })
            .disposed(by: bag)
        
        tapGesture.rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.toEditNicknameView()
            })
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

extension SettingViewController {
    func setRxButtonBinding() {
        
        locationButton.rx.controlEvent(.touchDown)
            .bind { [weak self] event in
                self?.locationButton.setBackgroundColor(CSColor._255_255_255_05.color)
            }
            .disposed(by: bag)
        
        locationButton.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchDragInside ])
            .bind { [weak self] event in
                self?.locationButton.setBackgroundColor(CSColor._245_245_245.color)
            }
            .disposed(by: bag)
    }
}

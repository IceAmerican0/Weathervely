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

final class SettingViewController: BaseViewController {
    
    var leftButtonDidTapRelay = PublishRelay<Void>()
    var bag = DisposeBag()
    
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
    private var bottomLable = CSLabel(.regular,12,"개인정보 처리 방침 및 정보 제공처")
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function)
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
                            flex.addItem(bottomLable)
                        }
                    bottomView.pin.bottom(to: contentWrapper.edge.bottom).marginBottom(5)
                    
                        
            }
        }
        
    }
    
    override func bind() {
        super.bind()
        
        // TODO: -
        // FIXME: - leftButton 액션 처리를 위한 임시조치 -> 후에 BaseViewModel을 만들어서 BaseViewController 와 연결시켜야한다.

        navigationView.leftButtonDidTapRelay
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        editButton.rx.tap
            .subscribe { [weak self] _ in
                self?.navigationController?.pushViewController(EditNicknameViewController(), animated: true)
            }.disposed(by: bag)
        
    }

}

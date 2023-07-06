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
        }
        
//        nickNameView.do {
//
//            $0.addBorder(.top)
//            $0.addBorder(.bottom)
//        }
        
        
        nickNameLabel.do {
            $0.adjustsFontSizeToFitWidth = true
        }
        
        editButton.do {
            $0.setImage(AssetsImage.editNameIcon.image, for: .normal)
        }
        
        stickerIcon.do {
            $0.image = AssetsImage.whiteHeart.image
        }
        
        messageLabel.do {
            $0.adjustsFontSizeToFitWidth = true
        }
        sensoryTempButton.do {
            $0.setShadow(CGSize(width: 0, height: 4), UIColor.black.cgColor, 0.25)
            $0.setTitle("체감 온도", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.imageView?.image = AssetsImage.settingTemperatureIcon.image
        }
        
        styleButton.do {
            $0.setShadow(CGSize(width: 0, height: 4), UIColor.black.cgColor, 0.25)
            $0.setTitle("스타일 선택", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.imageView?.image = AssetsImage.settingStyleIcon.image
        }
        
        locationButton.do {
            $0.setShadow(CGSize(width: 0, height: 4), UIColor.black.cgColor, 0.25)
            $0.setTitle("동네 설정", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.imageView?.image = AssetsImage.settingLoacationIcon.image
        }
        
        inquryButton.do {
            $0.setShadow(CGSize(width: 0, height: 4), UIColor.black.cgColor, 0.25)
            $0.setTitle("문의하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17,weight: .medium)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.imageView?.image = AssetsImage.settingInquryIcon.image
        }
        
//        bottomView.do {
//            $0.addBorder(.top)
//        }

        
        
    }

    // MARK: - Layout
    
    override func layout() {
        super.layout()
        container.flex.define { flex in
            flex.addItem(navigationView)
                .view?.addBorder(.bottom)
            
            flex.addItem(contentWrapper)
                .justifyContent(.spaceBetween)
                .alignContent(.stretch) // test용 코드
                .width(container.frame.width)
                .define { flex in

                    flex.addItem(nickNameView)
                        .marginHorizontal(32)
                        .define { flex in

                        flex.addItem(nickNameLabel)
                            .marginVertical(9)
                            .marginLeft(60)
                        flex.addItem(editButton)
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

                    flex.addItem(firstButtonWrapper).direction(.row)
                    .marginHorizontal(40)
                    .define { flex in
                        flex.addItem(sensoryTempButton)
                            .grow(1)
                            .shrink(1)
                            .marginRight(10)

                        flex.addItem(styleButton)
                            .grow(1)
                            .shrink(1)
                            .marginLeft(10)
                    }

                    flex.addItem(secondButtonWrapper).direction(.row)
                        .marginHorizontal(40)
                        .define { flex in
                            flex.addItem(locationButton)
                                .grow(1)
                                .shrink(1)
                                .marginRight(10)

                            flex.addItem(inquryButton)
                                .grow(1)
                                .shrink(1)
                                .marginLeft(10)
                        }
                    flex.addItem(bottomView)
            }
        }
        
    }

}

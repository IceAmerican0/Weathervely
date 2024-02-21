//
//  CSNavigationView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/05.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import Then

class CSNavigationView: UIView, CodeBaseInitializerProtocol {
    
    // MARK: - UI Component
    private let wrapperView = UIView()
    
    private var leftButton = UIButton()
    
    private var titleLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make()
    
    private var rightButton = UIButton().then {
        $0.isHidden = true
    }
    
    // MARK: - Control Property
    enum ButtonLayout {
        /// leftButton
        case leftButton(UIImage)
        /// leftButton & rightButton
        case rightButton(UIImage, UIImage)
    }
    
    var bag = DisposeBag()
    var leftButtonDidTapRelay = PublishRelay<Void>()
    var rightButtonDidTapRelay = PublishRelay<Void>()
    
    init(_ option: ButtonLayout) {
        super.init(frame: .zero)
        generateButton(option)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrapperView.pin.all()
        wrapperView.flex.layout()
    }
    
    private func generateButton(_ option: ButtonLayout) {
        switch option {
        case .leftButton(let image):
            leftButton.setImage(image, for: .normal)
        case .rightButton(let leftImage, let rightImage):
            leftButton.setImage(leftImage, for: .normal)
            
            rightButton.setImage(rightImage, for: .normal)
            rightButton.imageView?.contentMode = .scaleAspectFill
            rightButton.isHidden = false
        }
    }
    
    func layout() {
        backgroundColor = .clear
        self.addSubview(wrapperView)
        
        wrapperView.flex.direction(.row).alignItems(.center).justifyContent(.spaceBetween).height(44).define {
            $0.addItem(leftButton).marginLeft(20).size(24)
            $0.addItem(titleLabel).backgroundColor(.clear).grow(1)
            $0.addItem(rightButton).marginRight(20).size(24)
        }
    }
    
    // MARK: - Bind
    func bind() {
        leftButton.rx.tap
            .bind(to: leftButtonDidTapRelay)
            .disposed(by: bag)
        
        rightButton.rx.tap
            .bind(to: rightButtonDidTapRelay)
            .disposed(by: bag)
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setTitleColor(color: UIColor) {
        titleLabel.textColor = color
    }
}

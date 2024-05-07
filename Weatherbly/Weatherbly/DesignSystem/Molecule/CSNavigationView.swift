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

public final class CSNavigationView: UIView {
    
    // MARK: - UI Component
    private let wrapperView = UIView()
    
    private var leftButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private var titleLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make()
    
    private var rightButton = UIButton().then {
        $0.isHidden = true
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    // MARK: - Control Property
    enum ButtonLayout {
        /// leftButton
        case leftButton(UIImage)
        /// leftButton & rightButton
        case rightButton(UIImage, UIImage)
    }
    
    var bag = DisposeBag()
    
    var leftButtonDidTapRelay: Driver<Void> {
        self.leftButton.rx.tap.asDriver()
    }
    
    var rightButtonDidTapRelay: Driver<Void> {
        self.rightButton.rx.tap.asDriver()
    }
    
    init(_ option: ButtonLayout) {
        super.init(frame: .zero)
        generateButton(option)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        wrapperView.pin.all()
        wrapperView.flex.layout()
    }

    public func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    public func setTitleColor(color: UIColor) {
        titleLabel.textColor = color
    }
    
    public func hideLeftButton() {
        leftButton.isHidden = true
    }
}

// MARK: Layout
private extension CSNavigationView {
    private func generateButton(_ option: ButtonLayout) {
        switch option {
        case .leftButton(let image):
            leftButton.setImage(image, for: .normal)
        case .rightButton(let leftImage, let rightImage):
            leftButton.setImage(leftImage, for: .normal)
            
            rightButton.setImage(rightImage, for: .normal)
            rightButton.isHidden = false
        }
    }
    
    private func layout() {
        backgroundColor = .white
        self.addSubview(wrapperView)
        
        wrapperView.flex.direction(.row).alignItems(.center).justifyContent(.spaceBetween).height(44).define {
            $0.addItem(leftButton).marginLeft(20).size(24)
            $0.addItem(titleLabel).backgroundColor(.clear).grow(1)
            $0.addItem(rightButton).marginRight(20).size(24)
        }
    }
}

//
//  CSNavigationView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/05.
//

import ResourcePackage
import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import Then

public enum NavigationButtonLayout {
    /// leftButton
    case leftOnly(UIImage)
    /// leftButton & rightButton
    case both(UIImage, UIImage)
}

public final class CSNavigationView: UIView {
    
    // MARK: - UI Component
    private let wrapperView = UIView()
    
    private var leftButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private var titleLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make().then {
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private var rightButton = UIButton().then {
        $0.isHidden = true
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    public var leftButtonDidTapRelay: Driver<Void> {
        self.leftButton.rx.tap.asDriver()
    }
    
    public var rightButtonDidTapRelay: Driver<Void> {
        self.rightButton.rx.tap.asDriver()
    }
    
    public init(_ option: NavigationButtonLayout) {
        super.init(frame: .zero)
        generateButton(option)
        layout()
    }
    
    required public init?(coder: NSCoder) {
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
    private func generateButton(_ option: NavigationButtonLayout) {
        switch option {
        case .leftOnly(let image):
            leftButton.setImage(image, for: .normal)
        case .both(let leftImage, let rightImage):
            leftButton.setImage(leftImage, for: .normal)
            
            rightButton.setImage(rightImage, for: .normal)
            rightButton.isHidden = false
        }
    }
    
    private func layout() {
        backgroundColor = .white
        self.addSubview(wrapperView)
        
        wrapperView.flex.direction(.row).alignItems(.center).justifyContent(.spaceBetween).alignSelf(.stretch).height(44).define {
            $0.addItem(leftButton).marginLeft(20).size(24)
            $0.addItem(titleLabel).backgroundColor(.clear).shrink(1)
            $0.addItem(rightButton).marginRight(20).size(24)
        }
    }
}

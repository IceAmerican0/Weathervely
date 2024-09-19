//
//  CSButton.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit
import FlexLayout
import RxGesture
import RxSwift
import Then

public final class CSButton: UIButton {
    
    // MARK: - Control Property
    // 버튼 크기에 따라
    enum ButtonScale {
        case standard
        case compact
    }
    
    // 버튼 색상에 따라
    enum ButtonStyle {
        case violet600
        case violet100
        case white // -> border
    }
    
    var bag = DisposeBag()
    
    var scale: ButtonScale
    
    var style: ButtonStyle
    
    private lazy var indicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(_ scale: ButtonScale, style: ButtonStyle) {
        self.scale = scale
        self.style = style
        super.init(frame: .zero)
        buttonConfigure()
        setRxBinding()
        setIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        indicator.pin.center()
    }
    
    public override var isEnabled: Bool {
        didSet {
            buttonConfigure()
        }
    }
    
    /// 상태 초기화
    public func resetState() {
        bag = DisposeBag()
        buttonConfigure()
    }
    
    /// Loading Indicator On
    public func startAnimation() {
        titleLabel?.isHidden = true
        isUserInteractionEnabled = false
        indicator.flex.display(.flex)
        indicator.startAnimating()
    }
    
    /// Loading Indicator Off
    public func stopAnimation() {
        titleLabel?.isHidden = false
        isUserInteractionEnabled = true
        indicator.flex.display(.none)
        indicator.stopAnimating()
    }
}

private extension CSButton {
    /// Button Pressed effect
    func setRxBinding() {
        self.rx.controlEvent(.touchDown)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    switch owner.style {
                    case .violet600:
                        owner.backgroundColor = .violet400
                    case .violet100:
                        owner.backgroundColor = .violet200
                    case .white:
                        owner.backgroundColor = .violet50
                    }
                }
            ).disposed(by: bag)
        
        self.rx.controlEvent([.touchUpInside, .touchUpOutside])
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    switch owner.style {
                    case .violet600:
                        owner.backgroundColor = .violet600
                    case .violet100:
                        owner.backgroundColor = .violet100
                    case .white:
                        owner.backgroundColor = .white
                    }
                }
            ).disposed(by: bag)
    }
    
    /// bgColor, titleColor, font, radius, titleColor
    func buttonConfigure() {
        self.do {
            if scale == .standard {
                $0.titleLabel?.font = UIFont.title_3_B
                $0.layer.cornerRadius = 12
                
                switch style {
                case .violet600:
                    $0.backgroundColor = isEnabled ? .violet600 : .gray30
                    $0.setTitleColor(.white, for: .normal)
                    $0.setTitleColor(.white, for: .disabled)
                    
                case .violet100:
                    $0.backgroundColor = isEnabled ? .violet100 : .gray30
                    $0.setTitleColor(.violet600, for: .normal)
                    $0.setTitleColor(.white, for: .disabled)
                    
                case .white:
                    $0.backgroundColor = .white
                    $0.setTitleColor(.violet600, for: .normal)
                    $0.setTitleColor(.violet400, for: .highlighted)
                    $0.setTitleColor(.gray30, for: .disabled)
                    $0.layer.borderWidth = 1
                    $0.layer.borderColor = UIColor.violet150.cgColor
                }
            } else {
                $0.titleLabel?.font = UIFont.body_5_M
                $0.layer.cornerRadius = 5
                $0.backgroundColor = isEnabled ? .violet100 : .gray30
                $0.setTitleColor(.violet800, for: .normal)
                $0.setTitleColor(.white, for: .disabled)
            }
        }
    }
    
    func setIndicator() {
        flex.define {
            $0.addItem(indicator).display(.none)
        }
    }
}

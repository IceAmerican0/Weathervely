//
//  NewCSTextButton.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit
import FlexLayout
import RxGesture
import RxSwift

final public class NewCSButton: UIButton {
    
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
    var scale = ButtonScale.standard
    var style = ButtonStyle.violet600
    
    init(_ scale: ButtonScale, style: ButtonStyle) {
        self.scale = scale
        self.style = style
        super.init(frame: .zero)
        buttonConfigure()
        setRxBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isEnabled: Bool {
        didSet {
            buttonConfigure()
        }
    }
    
    /// Button Pressed effect
    func setRxBinding() {
        self.rx.controlEvent(.touchDown)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    switch owner.style {
                    case .violet600:
                        owner.setBackgroundColor(.violet400)
                    case .violet100:
                        owner.setBackgroundColor(.violet200)
                    case .white:
                        owner.setBackgroundColor(.violet50)
                        self.setTitleColor(.violet400, for: .highlighted)
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
                        owner.setBackgroundColor(.violet600)
                    case .violet100:
                        owner.setBackgroundColor(.violet100)
                    case .white:
                        owner.setBackgroundColor(.white)
                        self.setTitleColor(.violet600, for: .normal)
                    }
                }
            ).disposed(by: bag)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.scale == .standard {
            self.titleLabel?.font = UIFont.title_3_B
        } else {
            self.titleLabel?.font = UIFont.body_5_M
        }
    }
    
    /// bgColor, titleColor, font, radius, titleColor
    func buttonConfigure() {
        if scale == .standard {
            self.layer.cornerRadius = 12
            
            switch style {
            case .violet600:
                self.backgroundColor = isEnabled ? .violet600 : .gray30
                self.setTitleColor(.white, for: .normal)
                self.setTitleColor(.white, for: .disabled)
                
            case .violet100:
                self.backgroundColor = isEnabled ? .violet100 : .gray30
                self.setTitleColor(.violet600, for: .normal)
                self.setTitleColor(.white, for: .disabled)
                
            case .white:
                self.backgroundColor = .white
                self.setTitleColor(.violet600, for: .normal)
                self.setTitleColor(.gray30, for: .disabled)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.violet150.cgColor
            }
        } else {
            self.layer.cornerRadius = 5
            self.backgroundColor = isEnabled ? .violet100 : .gray30
            self.setTitleColor(.violet800, for: .normal)
            self.setTitleColor(.white, for: .disabled)
        }
    }
}



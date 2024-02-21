//
//  CSButton.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/12.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

class CSButton: UIButton {
    
    // MARK: - Control Property
    
    enum ButtonStyle {
        case primary
        case grayFilled
        case secondary
        case band
    }
    
    private var bag = DisposeBag()
    private var stateRelay = BehaviorRelay<UIControl.State?>(value: nil)
    var primaryHeight = UIScreen.main.bounds.height * 0.07
    
    init(_ buttonStyle: ButtonStyle) {
        super.init(frame: .zero)
        setButtonStyle(buttonStyle)
        setRxBinding(buttonStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRxBinding(_ style: ButtonStyle) {
        self.rx.controlEvent(.touchDown)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    switch style {
                    case .primary:
                        owner.setBackgroundColor(CSColor._236_207_255.color)
                    case .grayFilled:
                        owner.setBackgroundColor(CSColor._115_115_115_52.color)
                    default:
                        break
                    }
                })
            .disposed(by: bag)
        
        self.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchDragInside])
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    switch style {
                    case .primary:
                        owner.setBackgroundColor(CSColor._172_107_255.color)
                    case .grayFilled:
                        owner.setBackgroundColor(CSColor._151_151_151.color)
                    default:
                        break
                    }
                })
            .disposed(by: bag)
    }
    
    func setButtonStyle(_ style: ButtonStyle) {
        self.do {
            switch style {
            case .primary:
                // background disabled 처리
                //                if $0.state == .disabled {
                //                    $0.backgroundColor = CSColor._220_220_220.color
                //                } else if  $0.state == .highlighted {
                //                    $0.backgroundColor = .red
                //                } else {
                //                    $0.backgroundColor = CSColor._172_107_255.color
                //                }
                $0.setBackgroundColor(CSColor._172_107_255.color)
                $0.layer.cornerRadius = 10.0
                $0.titleLabel?.textColor = .white
                if UIScreen.main.bounds.width < 376 {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                } else {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
                }
                $0.setShadow(CGSize(width: 0, height: 3), CSColor._0__03.cgColor, 1, 2)
                
            case .grayFilled:
                if $0.isEnabled == true {
                    // background disabled 처리
                    if $0.state == .disabled {
                        $0.backgroundColor = CSColor._220_220_220.color
                    } else {
                        $0.backgroundColor = CSColor._151_151_151.color
                    }
                    
                } else {
                    $0.backgroundColor = CSColor._220_220_220.color
                }
                
                $0.layer.cornerRadius = 10.0
                $0.titleLabel?.textColor = .white
                
                if UIScreen.main.bounds.width < 376 {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                } else {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
                }
                
            case .secondary:
                $0.backgroundColor = .white
                $0.layer.borderWidth = 3
                $0.layer.cornerRadius = 21
                $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                
            case .band:
                $0.backgroundColor = .white
            }
        }
    }
}

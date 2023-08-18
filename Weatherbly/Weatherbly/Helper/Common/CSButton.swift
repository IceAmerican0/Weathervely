//
//  CSButton.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/12.
//

import UIKit
import PinLayout

class CSButton: UIButton, CodeBaseInitializerProtocol {
    
    // MARK: - Control Property
    
    enum ButtonStyle {
        case primary
        case grayFilled
        case secondary
        case band
    }
    
    private var buttonStyle: ButtonStyle
    var primaryHeight = UIScreen.main.bounds.height * 0.07
    
    init(_ buttonStyle: ButtonStyle) {
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        setButtonStyle(buttonStyle)
    }
    
    func setButtonStyle(_ style: ButtonStyle) {
        
        buttonStyle = style
        
        self.do {
            switch style {
            case .primary:
                // background disabled 처리
                if $0.state == .disabled {
                    $0.backgroundColor = CSColor._220_220_220.color
                } else if  $0.state == .highlighted {
                    $0.backgroundColor = .red
                } else {
                    $0.backgroundColor = CSColor._172_107_255.color
                }
                $0.layer.cornerRadius = 10.0
                $0.titleLabel?.textColor = .white
                if UIScreen.main.bounds.width < 376 {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                } else {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
                }
                $0.setShadow(CGSize(width: 0, height: 3), CSColor._0__03.cgColor, 1, 2)
                // TODO: - Hilighted 이미지 처리 필요
                // TODO: - buttonTitle 설정
                // setImage? or 함수?
                
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
                $0.setShadow(CGSize(width: 0, height: 3), CSColor._0__03.cgColor, 1, 2)
                
                if UIScreen.main.bounds.width < 376 {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                } else {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
                }
                // TODO: - Hilighted 이미지 처리 필요
                // TODO: - buttonTitle 설정
                
            case .secondary:
                $0.backgroundColor = .white
                $0.layer.borderWidth = 3
                $0.layer.cornerRadius = 21
                $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                // TODO: - Color 입력
                /// https://stackoverflow.com/questions/36836367/how-can-i-do-programmatically-gradient-border-color-uibutton-with-swift
                
            case .band:
                $0.backgroundColor = .white
            }
        }
    }
}

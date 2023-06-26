//
//  CSButton.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/12.
//

import UIKit

class CSButton: UIButton, CodeBaseInitializerProtocol {
    
    // MARK: - Control Property
    
    enum ButtonStyle {
        case primary
        case grayFilled
        case secondary
    }
    
    
    private var buttonStyle: ButtonStyle
    // MARK: - Initializer
    
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
        
        switch style {
        case .primary:
            
            self.do {
                

                // background disabled 처리
                if $0.state == .disabled {
                    $0.backgroundColor = CSColor._220_220_220.color
                } else if  $0.state == .highlighted {
                    $0.backgroundColor = .red
                } else {
                    $0.backgroundColor = CSColor._186_141_244.color
                }
                $0.layer.cornerRadius = 10.0
                $0.titleLabel?.textColor = .white
                $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
                $0.layer.shadowColor = CSColor._0__03.cgColor
                $0.layer.shadowOpacity = 1
                $0.layer.shadowOffset = CGSize(width: 0, height: 3)
                // TODO: - Hilighted 이미지 처리 필요
                // TODO: - buttonTitle 설정
                // setImage? or 함수?
            }
            
        case.grayFilled:
            
            self.do {
                
                if self.isEnabled == true {
                    // background disabled 처리
                    if $0.state == .disabled {
                        $0.backgroundColor = CSColor._220_220_220.color
                    } else {
                        $0.backgroundColor = CSColor._0__54.color
                    }
     
                } else {
                    self.backgroundColor = CSColor._220_220_220.color
                }
               
                $0.layer.cornerRadius = 10.0
                $0.titleLabel?.textColor = .white
                $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
                $0.layer.shadowColor = CSColor._0__03.cgColor
                $0.layer.shadowOpacity = 1
                $0.layer.shadowOffset = CGSize(width: 0, height: 3)
                // TODO: - Hilighted 이미지 처리 필요
                // TODO: - buttonTitle 설정
                
            }
            
            
        case .secondary:
            self.do {
                $0.backgroundColor = .white
                $0.layer.borderWidth = 3
                $0.layer.cornerRadius = 21
                $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
                // TODO: - Color 입력
                /// https://stackoverflow.com/questions/36836367/how-can-i-do-programmatically-gradient-border-color-uibutton-with-swift
            }
        }
    }
}

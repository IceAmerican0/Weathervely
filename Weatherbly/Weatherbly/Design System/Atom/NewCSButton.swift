//
//  NewCSTextButton.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit
import FlexLayout

/*
 
 
 issue 확인해야할 것
 case w 300 h 30 -> CSButton 내에서 지정해줬을떄 -> flex - > 1. 반쪽짜리 2개 가능?
 2. flex 에서 패딩만 줬을 떄, 버튼 크기 조절됌?
 */



final public class NewCSButton: UIButton {
    
    // MARK: - Control Property
    // 버튼 크기에 따라
    enum ButtonType {
        case standard
        case compact
    }
    
    // 버튼 색상에 따라
    enum ButtonStyle {
        case violet600
        case violet100
        case white // -> border
    }
    
    var font = UIFont()
    
    init (_ type: ButtonType, style: ButtonStyle) {
        super.init(frame: .zero)
        buttonConfigure(type, style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// bgColor, titleColor, font, radius, titleColor
    func buttonConfigure(_ type: ButtonType, _ style: ButtonStyle) {
        
        if type == .standard {
            font = UIFont.title_3_B!
            self.layer.cornerRadius = 12
            
            switch style {
            case .violet600:
                self.setBackgroundColor(UIColor(resource: .violet600))
                self.setTitleColor(.white, for: .normal)
                
            case .violet100:
                self.setBackgroundColor(UIColor(resource: .violet100))
                self.setTitleColor(UIColor(resource: .violet600), for: .normal)
                
            case.white:
                self.setBackgroundColor(.white)
                self.setTitleColor(UIColor(resource: .violet600), for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor(resource: .violet150).cgColor
            }
        } else {
            font = UIFont.body_2_M!
            self.layer.cornerRadius = 5
            self.setBackgroundColor(UIColor(resource: .violet100))
            self.setTitleColor(UIColor(resource: .violet800), for: .normal)
        }
        
    }
}



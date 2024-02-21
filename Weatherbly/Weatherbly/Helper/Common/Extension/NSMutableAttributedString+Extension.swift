//
//  NSMutableAttributedString+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/23.
//

import UIKit

extension NSMutableAttributedString {
    
    // 한 텍스트에서 두가지 이상 속성 섞일떄 -> Mutable
    // 한 텍스트에서 color 가 필요할떄는 textColor
    
    func regular(_ string: String, _ fontSize: CGFloat, _ color: CSColor) -> NSMutableAttributedString {
        var font = UIFont.systemFont(ofSize: fontSize)
        if UIScreen.main.bounds.width < 376 {
            font = UIFont.systemFont(ofSize: fontSize - 4)
        }
        let attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                         .foregroundColor: color.color]
        
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func medium(_ string: String, _ fontSize: CGFloat, _ color: CSColor) -> NSMutableAttributedString {
        var font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        if UIScreen.main.bounds.width < 376 {
            if fontSize > 12 {
                font = UIFont.systemFont(ofSize: fontSize - 4)
            }
            
        }
        let attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                         .foregroundColor: color.color]
        
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func bold(_ string: String, _ fontSize: CGFloat, _ color: CSColor) -> NSMutableAttributedString {
        
        var font = UIFont.boldSystemFont(ofSize: fontSize)
        if UIScreen.main.bounds.width < 376 {
            if fontSize > 12 {
                font = UIFont.systemFont(ofSize: fontSize - 4)
            }
        }
        let attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                         .foregroundColor: color.color]
        
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func underLine(_ string: String, _ fontSize: CGFloat, _ color: CSColor) -> NSMutableAttributedString {
        var font = UIFont.systemFont(ofSize: fontSize)
        if UIScreen.main.bounds.width < 376 {
            if fontSize > 12 {
                font = UIFont.systemFont(ofSize: fontSize - 4)
            }
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color.color
        ]
        
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}

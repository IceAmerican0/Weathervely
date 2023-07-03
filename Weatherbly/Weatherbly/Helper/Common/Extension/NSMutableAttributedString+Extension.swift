//
//  NSMutableAttributedString+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/23.
//

import UIKit

extension NSMutableAttributedString {
    
    func regular(_ string: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func bold(_ string: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func underLine(_ string: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}

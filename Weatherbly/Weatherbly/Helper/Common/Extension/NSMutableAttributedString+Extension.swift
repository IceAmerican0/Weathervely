//
//  NSMutableAttributedString+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/23.
//

import UIKit

extension NSMutableAttributedString {
    
    func regular(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes : [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func bold(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes : [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func underLine(string: String) -> NSMutableAttributedString {
        let attributes = NSMutableAttributedString(string: string)
        attributes.addAttribute(.underlineStyle,
                          value: NSUnderlineStyle.single.rawValue,
                          range: NSRange(location: 0, length: string.count))
        self.append(attributes)
        return self
    }
}

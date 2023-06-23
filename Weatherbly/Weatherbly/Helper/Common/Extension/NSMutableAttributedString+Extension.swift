//
//  NSMutableAttributedString+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/23.
//

import UIKit

extension NSMutableAttributedString {
    
    func regular(string: String, fontSize: CGFloat) {
        let font = UIFont.systemFont(ofSize: fontSize)
    }
    
    func bold(string: String, fontSize: CGFloat) {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    func underLine(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let underline = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: string, attributes: underline)
        return self
    }
    
    func returnValue(string: String, font: UIFont) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}

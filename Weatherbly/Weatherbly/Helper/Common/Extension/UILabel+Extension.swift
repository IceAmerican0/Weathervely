//
//  UILabel+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/18.
//

import UIKit

extension UILabel {
    
    func setLineHeight(_ height: CGFloat) {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = height
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.textAlignment = .center
        
    }
}

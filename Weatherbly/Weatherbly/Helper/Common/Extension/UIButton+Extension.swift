//
//  UIButton+.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit

extension UIButton {
    
    func setPressImage(_ image: UIImage) {
        self.setImage(image, for: .highlighted)
    }
    
    func alignTextBelowImage(spacing: CGFloat = 16) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [NSAttributedString.Key.font : titleLabel.font as Any])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}

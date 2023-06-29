//
//  UIView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit

extension UIView {
    
    func setShadow(_ size: CGSize, _ color: CGColor?, _ opacity: Float) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
        
    }
}

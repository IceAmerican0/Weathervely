//
//  CALayer+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/16.
//

import UIKit

extension CALayer {
    func setShadow(_ size: CGSize, _ color: CGColor?, _ opacity: Float, _ radius: CGFloat?) {
            
            self.shadowOffset = size
            self.shadowColor = color
            self.shadowOpacity = opacity
        
            if let radius = radius {
                self.shadowRadius = radius
            }
        
        }
 }

extension CAGradientLayer {
    func setGradient(color: [CGColor], locations: [NSNumber]? , _ radius: CGFloat?) {
        
        self.cornerRadius = radius ?? 0
        self.colors = color
        self.locations = locations
        self.startPoint = CGPoint(x: 0.5, y: 0)
        self.endPoint = CGPoint(x: 0.5, y: 1)
        
    }
}

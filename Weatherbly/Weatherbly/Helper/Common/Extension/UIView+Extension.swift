//
//  UIView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit
import FlexLayout
import PinLayout
import UIViewBorders

extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
        }
    }
    
    enum BorderDirection {
        case top
        case right
        case bottom
        case left
    }
    
    func addBorder(_ direction: BorderDirection, _ borderWidth: CGFloat = 1, _ borderColor: UIColor = CSColor._220_220_220.color) {
        
        switch direction {
        case .top:
            self.addBorderViews(positions: .top, color: borderColor, width: borderWidth)
        case .left:
            self.addBorderViews(positions: .left, color: borderColor, width: borderWidth)
        case .right:
            self.addBorderViews(positions: .right, color: borderColor, width: borderWidth)
        case .bottom:
            self.addBorderViews(positions: .bottom, color: borderColor, width: borderWidth)
            
        }
    }
        
    func setShadow(_ size: CGSize, _ color: CGColor?, _ opacity: Float, _ radius: CGFloat?) {
            
            self.layer.shadowOffset = size
            self.layer.shadowColor = color
            self.layer.shadowOpacity = opacity
        
            if let radius = radius {
                self.layer.shadowRadius = radius
            }
        
        }
    
    func setCornerRadius(_ radius: CGFloat?) {
        self.layer.cornerRadius = radius ?? 0
        }
        
        // 확인해보기
        func gradientLayer(color: (start: CGColor, end: CGColor), position: (start: CGPoint, end: CGPoint)) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.colors = [color.start, color.end]
            gradientLayer.startPoint = position.start
            gradientLayer.endPoint = position.end
            gradientLayer.frame = self.bounds
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        func setBackgroundWithCSColor(_ cscolor: CSColor) {
            self.backgroundColor = cscolor.color
        }
        
        func setBackgroundColor(_ color: UIColor) {
            self.backgroundColor = color
        }
        
        func hide() {
            self.isHidden = true
        }
        
        func show() {
            self.isHidden = false
        }
    
    
    }


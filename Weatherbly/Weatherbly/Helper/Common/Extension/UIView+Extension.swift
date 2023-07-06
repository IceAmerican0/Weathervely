//
//  UIView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit
import FlexLayout
import PinLayout

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
    
    func addBorder(_ direction: BorderDirection, _ borderWidth: CGFloat = 1, _ borderColor: UIColor = .black
//                   CSColor._212_195_233_39.color
    ) {
        
        let borderWrapper = UIView()
        let border = UIView()
        
        self.addSubview(borderWrapper)
        borderWrapper.pin.all()
        borderWrapper.flex.layout()
        
        
        borderWrapper.flex.define { flex in
            
            switch direction {
            case .top:
                flex.addItem(border).define { flex in
                        flex.width(self.frame.width)
                        flex.height(borderWidth)
                }
            case .left:
                flex.direction(.row)
                flex.addItem(border).define { flex in
                        flex.width(borderWidth)
                        flex.height(self.frame.height)
                }
                    
            case .right:
                flex.direction(.rowReverse)
                
                flex.addItem(border).define { flex in
                        flex.width(borderWidth)
                    flex.height(self.frame.height)
                }
            case .bottom:
                flex.direction(.columnReverse)
                
                flex.addItem(border).define { flex in
                    flex.width(self.frame.width)
                    flex.height(borderWidth)
                }
                print(self.frame.width)
                print(self.frame.height)
            }
            
        }
//        self.addSubview(border)
//        border.pin.all()
//            switch direction {
//            case .top:
//                border.pin.top(to: self.edge.top)
//                border.pin.width(self.frame.width)
//                border.pin.horizontally()
//                border.pin.height(borderWidth)
//            case .right:
//                border.pin.right(to: self.edge.right)
//                border.pin.width(borderWidth)
//                border.pin.vertically()
//                border.pin.height(self.frame.height)
//            case .bottom:
//                border.pin.bottom(to: self.edge.bottom)
//                border.pin.width(self.frame.width)
//                border.pin.horizontally()
//                border.pin.height(borderWidth)
//            case .left:
//                border.pin.left(to: self.edge.left)
//                border.pin.width(borderWidth)
//                border.pin.vertically()
//                border.pin.height(self.frame.height)
//            }
            border.backgroundColor = borderColor
        }
        
    
    func setShadow(_ size: CGSize, _ color: CGColor?, _ opacity: Float) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
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

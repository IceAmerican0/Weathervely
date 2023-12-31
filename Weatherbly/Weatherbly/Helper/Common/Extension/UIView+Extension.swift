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
import Then

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
    
    func addBorders(_ direction: [BorderDirection], _ borderWidth: CGFloat = 1, _ borderColor: UIColor = CSColor._220_220_220.color) {
        
        direction.forEach { direct in
            switch direct {
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
        
    func addGradientLayer(_ caGradientLayer: CAGradientLayer) {
        caGradientLayer.frame = self.bounds
        self.layer.insertSublayer(caGradientLayer, at: 0)
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
    
    func showToast(message : String, font: UIFont) {
        let y: CGFloat = {
            var y = CGFloat()

            if UIScreen.main.bounds.width < 376 {
                y = (self.frame.size.height - 42) - UIScreen.main.bounds.height * 0.17
            } else {
                y = (self.frame.size.height - 42) - UIScreen.main.bounds.height * 0.2
            }
           return y
        }()
        
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width * 0.05, y: y, width: self.frame.size.width * 0.89, height: 42)).then {
            $0.backgroundColor = CSColor._102_102_102.color.withAlphaComponent(0.7)
            $0.textColor = UIColor.white
            $0.font = font
            $0.textAlignment = .center
            $0.text = message
            $0.alpha = 1.0
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.adjustsFontSizeToFitWidth = true
        }
        
        
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }

    }


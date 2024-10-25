//
//  ShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/14/24.
//

import ResourcePackage
import UIKit
import Then

public final class ShimmerView: UIView {
    
    var start: [NSNumber] = [-1.0, -0.5, 0.0]
    var end: [NSNumber] = [1.0, 1.5, 2.0]
    
    var animationDuration: CFTimeInterval = 0.7
    var animationDelay: CFTimeInterval = 0.7
    
    var gradient: CAGradientLayer?
    
    public init(radius: CGFloat) {
        super.init(frame: .zero)
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradient = CAGradientLayer().then {
            $0.frame = bounds
            $0.startPoint = CGPoint(x: 0, y: 1)
            $0.endPoint = CGPoint(x: 1, y: 1)
            $0.colors = [UIColor.gray10.cgColor, UIColor.gray20.cgColor, UIColor.gray10.cgColor]
            $0.locations = start
        }
        
        layer.sublayers = [gradient]
        self.gradient = gradient
        startAnimation()
    }
    
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        clipsToBounds = true
        
        return self
    }
}

private extension ShimmerView {
    func startAnimation() {
        isHidden = false
        
        let animation = CABasicAnimation(keyPath: "locations").then {
            $0.fromValue = start
            $0.toValue = end
            $0.duration = animationDuration
            $0.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        
        let animationGroup = CAAnimationGroup().then {
            $0.isRemovedOnCompletion = false
            $0.duration = animationDuration + animationDelay
            $0.animations = [animation]
            $0.repeatCount = .infinity
        }
        
        self.gradient?.add(animationGroup, forKey: animation.keyPath)
    }
}

//
//  UIView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/16.
//

import UIKit
import FlexLayout
import PinLayout
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
    
    func addBorder(
        _ direction: BorderDirection,
        _ borderWidth: CGFloat = 1,
        _ borderColor: UIColor = CSColor._220_220_220.color
    ) {
        switch direction {
        case .top:
            self.addBorderViews(
                positions: .top,
                color: borderColor,
                width: borderWidth
            )
        case .left:
            self.addBorderViews(
                positions: .left,
                color: borderColor,
                width: borderWidth
            )
        case .right:
            self.addBorderViews(
                positions: .right,
                color: borderColor,
                width: borderWidth
            )
        case .bottom:
            self.addBorderViews(
                positions: .bottom,
                color: borderColor,
                width: borderWidth
            )
        }
    }
    
    func addBorders(
        _ direction: [BorderDirection],
        _ borderWidth: CGFloat = 1,
        _ borderColor: UIColor = CSColor._220_220_220.color
    ) {
        direction.forEach { direct in
            switch direct {
            case .top:
                self.addBorderViews(
                    positions: .top,
                    color: borderColor,
                    width: borderWidth
                )
            case .left:
                self.addBorderViews(
                    positions: .left,
                    color: borderColor,
                    width: borderWidth
                )
            case .right:
                self.addBorderViews(
                    positions: .right,
                    color: borderColor,
                    width: borderWidth
                )
            case .bottom:
                self.addBorderViews(
                    positions: .bottom,
                    color: borderColor,
                    width: borderWidth
                )
            }
        }
    }
    
    func setShadow(
        _ size: CGSize,
        _ color: CGColor?,
        _ opacity: Float,
        _ radius: CGFloat?
    ) {
        self.layer.shadowOffset = size
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        
        if let radius = radius {
            self.layer.shadowRadius = radius
        }
    }
    
    func setCornerRadius(
        _ radius: CGFloat,
        _ corners: UIRectCorner = .allCorners
    ) {
        var cornerMask = CACornerMask()
        
        if(corners.contains(.topLeft)) {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        if(corners.contains(.topRight)) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        if(corners.contains(.bottomLeft)) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        if(corners.contains(.bottomRight)) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = cornerMask
    }
    
    func addGradientLayer(_ caGradientLayer: CAGradientLayer) {
        caGradientLayer.frame = self.bounds
        self.layer.insertSublayer(caGradientLayer, at: 0)
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}

public struct Positions: OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let top = Positions(rawValue: 1 << 0)
    public static let left = Positions(rawValue: 1 << 1)
    public static let bottom = Positions(rawValue: 1 << 2)
    public static let right = Positions(rawValue: 1 << 3)
}

extension UIView {
    public func addBorderViews(
        positions: Positions,
        color: UIColor = .black,
        width: CGFloat = 1.0
    ) {
        if positions.contains(.top) {
            let borderView = UIView()
            borderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(borderView)
            borderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            borderView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            borderView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            borderView.heightAnchor.constraint(equalToConstant: width).isActive = true
            borderView.backgroundColor = color
        }
        if positions.contains(.left) {
            let borderView = UIView()
            borderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(borderView)
            borderView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            borderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            borderView.widthAnchor.constraint(equalToConstant: width).isActive = true
            borderView.backgroundColor = color
        }
        if positions.contains(.bottom) {
            let borderView = UIView()
            borderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(borderView)
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            borderView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            borderView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            borderView.heightAnchor.constraint(equalToConstant: width).isActive = true
            borderView.backgroundColor = color
        }
        if positions.contains(.right) {
            let borderView = UIView()
            borderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(borderView)
            borderView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            borderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            borderView.widthAnchor.constraint(equalToConstant: width).isActive = true
            borderView.backgroundColor = color
        }
    }
}

// MARK: Gradient
extension UIView {
    public func setWeatherUI(weather: String, time: String) -> ([UIColor], UIImage) {
        let isAM = time.isAM()
        
        return switch weather {
        case "맑음": isAM ?
            (.gradient10, UIImage.sunny_am) :
            (.gradient20, UIImage.sunny_pm)
        case "흐림": (.gradient30, UIImage.cloudy)
        case "구름많음": isAM ?
            (.gradient40, UIImage.clouds_am) :
            (.gradient50, UIImage.clouds_pm)
        case "비": (.gradient60, UIImage.rainy)
        case "눈비": (.gradient70, UIImage.snowyRainy)
        case "눈": (.gradient80, UIImage.snowy)
        case "바람": (.gradient90, UIImage.windy)
        default: (.gradient10, UIImage.sunny_am)
        }
    }
    
    func addGradient(colors: [UIColor]) {
        let gradient = CAGradientLayer().then {
            $0.colors = colors.map { $0.cgColor }
            $0.locations = [0, 1]
            $0.startPoint = CGPoint(x: 0.25, y: 0.5)
            $0.endPoint = CGPoint(x: 0.75, y: 0.5)
//            $0.transform = CATransform3DMakeAffineTransform(
//                CGAffineTransform(
//                    a: 0.97, b: 0.95, c: -0.85, d: 0.6, tx: 0.44, ty: -0.3
//            ))
            $0.bounds = bounds.insetBy(
                dx: (-0.5 * bounds.size.width),
                dy: (-0.5 * bounds.size.height)
            )
            $0.position = center
        }
        
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        layer.insertSublayer(gradient, at: 0)
    }
}

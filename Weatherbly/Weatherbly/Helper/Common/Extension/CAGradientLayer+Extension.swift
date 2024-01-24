//
//  CAGradientLayer+Extension.swift
//  Weatherbly
//
//  Created by Khai on 1/12/24.
//

import UIKit
import Then

extension CAGradientLayer {
    func makeGradient(colors: [UIColor]) -> CAGradientLayer {
        CAGradientLayer().then {
            $0.colors = colors.map { $0.cgColor }
            $0.locations = [0, 1]
            $0.startPoint = CGPoint(x: 0.25, y: 0.5)
            $0.endPoint = CGPoint(x: 0.75, y: 0.5)
            $0.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
//            $0.transform = CATransform3DMakeAffineTransform(
//                CGAffineTransform(a: 0.97, b: 0.95, c: -0.85, d: 0.6, tx: 0.44, ty: -0.3
//            ))
        }
    }
}

// MARK: Custom Gradient
extension CAGradientLayer {
    static let gradient10 = CAGradientLayer().makeGradient(colors: [.violet500, .blue500])
    static let gradient20 = CAGradientLayer().makeGradient(colors: [.violet500, .gray100])
    static let gradient30 = CAGradientLayer().makeGradient(colors: [.violet150, .gradient30])
    static let gradient40 = CAGradientLayer().makeGradient(colors: [.blue200, .gradient40])
    static let gradient50 = CAGradientLayer().makeGradient(colors: [.gray60, .gray400])
    static let gradient60 = CAGradientLayer().makeGradient(colors: [.blue500, .gray70])
    static let gradient70 = CAGradientLayer().makeGradient(colors: [.blue500, .gradient70])
    static let gradient80 = CAGradientLayer().makeGradient(colors: [.blue200, .blue700])
    static let gradient90 = CAGradientLayer().makeGradient(colors: [.violet500, .blue300])
}

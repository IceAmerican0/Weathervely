//
//  UIImage+.swift
//  DesignSystem
//
//  Created by Khai on 11/7/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

public extension UIImage {
    /// Custom SwipeAction
    func setSwipeActionView(
        size: CGSize,
        color: UIColor,
        radius: CGFloat,
        text: String? = nil,
        image: UIImage? = nil,
        textColor: UIColor = .white
    ) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius)
            color.setFill()
            path.fill()
            
            if let image {
                let imageSize = CGSize(width: 24, height: 24)
                let rect = CGRect(
                    x: (size.width - imageSize.width) / 2,
                    y: (size.height - imageSize.height) / 2,
                    width: imageSize.width,
                    height: imageSize.height
                )
                return image.draw(in: rect)
            }
            
            guard let text else { return }
            
            let attribute: [NSAttributedString.Key: Any] = [
                .font: UIFont.body_5_M,
                .foregroundColor: textColor
            ]
            
            let textSize = text.size(withAttributes: attribute)
            let rect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: rect, withAttributes: attribute)
        }
    }
}

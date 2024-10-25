//
//  UIImage+Extension.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit

extension UIImage {
    /// 이미지 크기 조절 및 배경색 설정
    func reDesign(size: CGSize, backgroundColor: UIColor? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        if let backgroundColor {
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)
            backgroundColor.setFill()
            path.fill()
            
            self.draw(in: rect)
        } else {
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
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

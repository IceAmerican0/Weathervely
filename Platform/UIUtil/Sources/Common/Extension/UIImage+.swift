//
//  UIImage+.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit

public extension UIImage {
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
}

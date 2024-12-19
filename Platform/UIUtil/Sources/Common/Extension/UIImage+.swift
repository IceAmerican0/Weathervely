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
        let format = UIGraphicsImageRendererFormat()
        format.preferredRange = .standard
        let rect = CGRect(origin: .zero, size: size)
        
        return UIGraphicsImageRenderer(bounds: rect, format: format).image { _ in
            if let backgroundColor {
                let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)
                backgroundColor.setFill()
                path.fill()
                
                self.draw(in: rect)
            } else {
                self.draw(in: rect)
            }
        }
    }
}

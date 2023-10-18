//
//  UIImage+Extension.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit

extension UIImage {
    /// 이미지 크기 조절
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}

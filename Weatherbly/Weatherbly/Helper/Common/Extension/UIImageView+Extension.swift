//
//  UIImageView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/19.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    convenience init(_ assetEnum: AssetsImage) {
        self.init(image: assetEnum.image)
    }
    
    func setAssetsImage(_ assetEnum: AssetsImage) {
        self.image = assetEnum.image
    }
    
    func setIndicator() {
        self.kf.indicatorType = .activity
//        lazy var indicator = UIActivityIndicatorView()
//        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        indicator.center = self.center
//        
//        self.addSubviews(indicator)
//        indicator.startAnimating()
    }
}

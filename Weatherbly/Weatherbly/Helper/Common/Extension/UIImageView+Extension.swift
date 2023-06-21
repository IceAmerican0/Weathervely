//
//  UIImageView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/19.
//

import UIKit

extension UIImageView {
    
    convenience init(_ assetEnum: AssetsImage) {
        self.init(image: assetEnum.image)
    }
    
    func setAssetsImage(_ assetEnum: AssetsImage) {
        self.image = assetEnum.image
    }
}

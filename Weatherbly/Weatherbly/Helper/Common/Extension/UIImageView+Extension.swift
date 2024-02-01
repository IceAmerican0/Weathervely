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
    
    /// Setting Kingfisher Image
    func setKF(
        urlString: String,
        placeHolder: UIImage? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        guard !urlString.isEmpty else { return }
        
        let url = URL(string: urlString)
        
        let retryStrategy = DelayRetryStrategy(
            maxRetryCount: 2,
            retryInterval: .seconds(2)
        )
        
        self.kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .retryStrategy(retryStrategy),
                .transition(.fade(0.1)),
                .cacheOriginalImage
            ]
        ) { result in
            completionHandler?(result)
        }
    }
}

//
//  UIImageView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/19.
//  Fixed by 최수훈 on 2024/05/30

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
            retryInterval: .seconds(0.1)
        )
        
        self.kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .retryStrategy(retryStrategy),
                .transition(.fade(1)),
                .cacheOriginalImage,
            ]
        ) { result in
            completionHandler?(result)
            switch result {
            case .success(let value):
                break
            case .failure(let error):
                print("imageDownLoad 실패!!!")
                self.image = placeHolder
                completionHandler?(.failure(error))
            }
        }
    }
}

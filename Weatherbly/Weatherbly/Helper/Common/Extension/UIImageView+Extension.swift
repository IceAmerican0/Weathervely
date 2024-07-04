//
//  UIImageView+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/19.
//  Fixed by 최수훈 on 2024/05/30

import UIKit
import Kingfisher

extension UIImageView {
    /// Setting Kingfisher Image
    func setKF(
        urlString: String,
        placeHolder: UIImage? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        guard !urlString.isEmpty else {
            self.image = placeHolder
            self.contentMode = .center
            return
        }
        
        let emptyView = ShimmerView()
        emptyView.backgroundColor = .gray10
        emptyView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        emptyView.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        
        DispatchQueue.main.async {
            self.addSubview(emptyView)
        }
        
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
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                emptyView.removeFromSuperview()
            }
            
            switch result {
            case .success:
                self.contentMode = .scaleAspectFill
            case .failure:
                self.contentMode = .center
                self.image = placeHolder
            }
            completionHandler?(result)
        }
    }
}

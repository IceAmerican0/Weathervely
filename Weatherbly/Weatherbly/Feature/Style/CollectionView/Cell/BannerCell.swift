//
//  BannerCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 4/27/24.
//

import UIKit
import FlexLayout
import PinLayout

final class BannerCell: UICollectionViewCell {
    
     var bannerImageView = UIImageView().then {
        $0.image = UIImage.style_banner
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.image = UIImage.style_banner
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    private func cellLayout() {
        
        contentView.flex.define { contentView in
            contentView.addItem(bannerImageView).margin(0, 0, 0, 20).height(80)
        }
    }
    
}

//
//  HomeClosetBannerCell.swift
//  Weatherbly
//
//  Created by Khai on 1/4/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public final class HomeClosetBannerCell: UICollectionViewCell {
    
    let banner = UIImageView().then {
        $0.image = .home_banner_01
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.define {
            $0.addItem(banner).size(158)
        }
    }
}

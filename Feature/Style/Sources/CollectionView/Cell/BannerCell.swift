//
//  BannerCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 4/27/24.
//

import ResourcePackage
import UIKit
import FlexLayout
import PinLayout
import Then

public final class BannerCell: UICollectionViewCell {
     private var bannerImageView = UIImageView().then {
         $0.image = .style_banner
         $0.contentMode = .scaleAspectFill
         $0.layer.cornerRadius = 12
         $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    private func setLayout() {
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.define {
            $0.addItem(bannerImageView).grow(1)
        }
    }
}

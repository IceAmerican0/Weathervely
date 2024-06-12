//
//  MainDetailCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import UIKit
import FlexLayout
import PinLayout

final class MainDetailCell: UICollectionViewCell {
    
    public var shopLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "shopName")
    
    public var detailImageView = UIImageView().then {
        $0.image = UIImage.image_indicator
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.define {
            $0.addItem(shopLabel).height(44)
            $0.addItem(detailImageView).width(100%).height(562.5)
        }
    }
    
    func configure(info: SelectedClosetInfo?) {
        guard let info = info else { return }
        if let imageUrl = info.imageUrl,
           let shopName = info.shopName {
            detailImageView.setKF(urlString: imageUrl)
            shopLabel.text = shopName
        }
    }
}

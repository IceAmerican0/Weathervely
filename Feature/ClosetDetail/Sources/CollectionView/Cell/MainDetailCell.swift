//
//  MainDetailCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import DesignSystem
import WVNetwork
import UIKit
import FlexLayout
import PinLayout
import Then

final class MainDetailCell: UICollectionViewCell {
    
    public var shopLabel = LabelMaker(
        font: UIFont.title_3_B
    ).make(text: "shopName").then {
        $0.backgroundColor = .white
    }
    
    public var detailImageView = UIImageView().then {
        $0.contentMode = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
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
        contentView.flex.direction(.column).define {
            $0.addItem(shopLabel).height(44).marginLeft(20)
            $0.addItem(detailImageView).marginTop(10).width(100%).height(562.6)
        }
    }
    
    func configure(info: SelectedClosetInfo?) {
        guard let info else { return }
        if let imageUrl = info.imageUrl,
           let shopName = info.shopName {
            
            self.detailImageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] result in
                guard let self else { return }
                self.layoutIfNeeded()
            }
            shopLabel.text = shopName
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailImageView.image = nil
        self.detailImageView.contentMode = .center
    }
}

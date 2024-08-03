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
    ).make(text: "shopName").then {
        $0.backgroundColor = .white
    }
    
    public var imageWrapper = UIView()
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
        layout()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.direction(.column).define {
            $0.addItem(shopLabel).height(44).marginLeft(20)
            $0.addItem(imageWrapper).width(100%).backgroundColor(UIColor.gray10).define { wrapper in
                wrapper.addItem(detailImageView).height(562.6)
            }
        }
    }
    
    func configure(info: SelectedClosetInfo?) {
        guard let info = info else { return }
        if let imageUrl = info.imageUrl,
           let shopName = info.shopName {
            
            self.detailImageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] result in
                switch result {
                case .success:
                    self?.detailImageView.contentMode = .scaleAspectFit
                    self?.detailImageView.pin.all()
                    
                case .failure:
                    self?.detailImageView.image?.resized(to: CGSize(width: 56, height: 56))
                    self?.detailImageView.contentMode = .center
                    self?.detailImageView.pin.all()
                    
                }
                self?.detailImageView.flex.markDirty()
                self?.detailImageView.layoutIfNeeded()
                self?.detailImageView.setNeedsLayout()
            }
            shopLabel.text = shopName
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailImageView.image = nil
    }
}

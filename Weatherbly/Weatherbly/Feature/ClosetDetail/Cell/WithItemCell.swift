//
//  WithItemCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/10/24.
//

import UIKit
import FlexLayout
import PinLayout

final class WithItemCell: UICollectionViewCell {
    
    let imagePlaceHolder = UIImage.image_indicator
    
    private var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private var itemImage = UIImageView().then {
        $0.image = UIImage.image_indicator
        $0.contentMode = .scaleAspectFit
    }
    private var itemNameLabel = LabelMaker(
        font: UIFont.body_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "ItemName").then {
        $0.numberOfLines = 1
    }
    
    private var shopNameLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray100,
        alignment: .left
    ).make(text: "ItemShopName").then {
        $0.numberOfLines = 1
    }
    
    private var categoryLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray50,
        alignment: .left
    ).make(text: "category").then {
        $0.numberOfLines = 1
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
        contentView.flex.direction(.column).define {
            $0.addItem(imageViewWrapper).backgroundColor(UIColor.gray10).define {
                $0.addItem(itemImage).height(180).alignSelf(.center)
            }
            $0.addItem(itemNameLabel).height(itemNameLabel.font.setLineHeight()).marginTop(4) // 19
            $0.addItem(shopNameLabel).height(shopNameLabel.font.setLineHeight()).marginTop(4) // 17
            $0.addItem(categoryLabel).height(categoryLabel.font.setLineHeight()) // 17
        }
    }
    
    func configure(info: WithItemsInfo?) {
        guard let info = info else { return }
        if let category = info.category?.categoryName,
            let imageUrl = info.imageUrl,
           let shopUrl = info.shopUrl,
           let itemName = info.name,
           let brandName = info.brandName,
           let status = info.status {
               itemImage.setKF(urlString: imageUrl, placeHolder: imagePlaceHolder) { [weak self] result in
                   switch result {
                   case.success:
                       self?.itemImage.pin.all()
                       self?.itemImage.contentMode = .scaleAspectFit
                   case .failure:
                       self?.itemImage.pin.all()
                       self?.itemImage.contentMode = .center
                       self?.flex.alignSelf(.center)
                       self?.itemImage.flex.layout()
                   }
                   // FlexLayout 레이아웃 업데이트
                   self?.itemImage.flex.markDirty()
                   self?.itemImage.setNeedsLayout()
                   self?.itemImage.layoutIfNeeded()
               }
            itemNameLabel.text = itemName
            shopNameLabel.text = brandName
            categoryLabel.text = category
        }
    }
}


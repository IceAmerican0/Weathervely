//
//  WithItemCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/10/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa

final class WithItemCell: UICollectionViewCell {
    
    let imagePlaceHolder = UIImage.image_indicator
    private var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
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
    
    private var soldOutView = LabelMaker.init(
        font: UIFont.body_3_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "SOLD OUT").then {
        $0.layer.opacity = 0.3
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        contentView.pin.all()
    }
    
    func layout() {
        
        contentView.addSubviews(imageViewWrapper
                                ,itemNameLabel
                                ,shopNameLabel
                                ,categoryLabel)
        imageViewWrapper.addSubviews(itemImage, soldOutView)
        
        imageViewWrapper.pin.top().horizontally().height(180)
        itemImage.pin.all()
        soldOutView.pin.all()
        
        itemNameLabel.pin.below(of: imageViewWrapper).horizontally().height(itemNameLabel.font.setLineHeight()).marginTop(12)
        shopNameLabel.pin.below(of: itemNameLabel).horizontally().height(shopNameLabel.font.setLineHeight()).marginVertical(4)
        categoryLabel.pin.below(of: shopNameLabel).horizontally().height(categoryLabel.font.setLineHeight())
    }
    
    func configure(info: WithItemsInfo?) {
        
        guard let info = info else { return }
        let id = info.id
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
                self?.layoutUpdate(view: self?.itemImage)
            }
            
            itemNameLabel.text = itemName
            shopNameLabel.text = brandName
            categoryLabel.text = category
            if isSoldOut(status) { isHiddenToggle() }
        }
        
    }
    
    func isSoldOut(_ status: String) -> Bool {
        (status == "sold_out") ? true : false
    }
    
    func isHiddenToggle() {
        soldOutView.isHidden.toggle()
        // FIXME: - 인터렉션 막던지 alert 띄우기 의논해보기
        self.isUserInteractionEnabled = false
    }
    
    func layoutUpdate(view: UIView?) {
        view!.flex.markDirty()
        view!.setNeedsLayout()
        view!.layoutIfNeeded()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemImage.image = nil
        self.soldOutView.isHidden = true
    }
}


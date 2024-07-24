//
//  WithItemCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/10/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxGesture
import RxCocoa
import Kingfisher

final class WithItemCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    let imagePlaceHolder = UIImage.image_indicator
    private var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.gray10
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
    
    public var itemTap: Driver<Void> {
        itemImage.rx.tapGesture().when(.ended).map { _ in }.asDriver(onErrorJustReturn: ())
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
        clipsToBounds = true
        layer.masksToBounds = false
        layer.setShadow(
            CGSize(width: 4, height: 4),
            UIColor.dark12.cgColor, 1, 4
        )
        
        imageViewWrapper.layer.masksToBounds = true
        imageViewWrapper.setCornerRadius(12)
        
        contentView.addSubviews(imageViewWrapper
                                ,itemNameLabel
                                ,shopNameLabel
                                ,categoryLabel)
        imageViewWrapper.addSubviews(itemImage, soldOutView)
        
        imageViewWrapper.pin.top().horizontally().height(180)
        itemImage.pin.all()
        soldOutView.pin.all()
        
        itemNameLabel.pin.below(of: imageViewWrapper).horizontally().height(itemNameLabel.font.setLineHeight()).marginTop(12)
        shopNameLabel.pin.below(of: itemNameLabel).horizontally().height(shopNameLabel.font.setLineHeight())/*.marginVertical(4)*/
//        categoryLabel.pin.below(of: shopNameLabel).horizontally().height(categoryLabel.font.setLineHeight())
    }
    
    func configure(info: WithItemsInfo?) {
        
        guard let info = info else { return }
        if let imageUrl = info.imageUrl,
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
//            categoryLabel.text = category
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
        self.itemImage.kf.cancelDownloadTask()
        self.soldOutView.isHidden = true
        bag = DisposeBag()
    }
}


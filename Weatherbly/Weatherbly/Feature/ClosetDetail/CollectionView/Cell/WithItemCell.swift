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
    
    private var imageViewWrapper = UIView().then {
        $0.layer.setShadow(
            CGSize(width: 4, height: 4),
            UIColor.dark12.cgColor, 1, 4
        )
    }
    
    private var itemImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.setCornerRadius(12)
        $0.contentMode = .scaleAspectFit
    }
    
    private var itemNameLabel = LabelMaker(
        font: UIFont.body_3_B
    ).make(text: "ItemName").then {
        $0.numberOfLines = 1
    }
    
    private var shopNameLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray100
    ).make(text: "ItemShopName").then {
        $0.numberOfLines = 1
    }
    
    private var categoryLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray50
    ).make(text: "category").then {
        $0.numberOfLines = 1
    }
    
    private var soldOutView = LabelMaker.init(
        font: UIFont.body_3_B,
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
        layer.masksToBounds = false
        
        contentView.addSubviews(imageViewWrapper
                                ,itemNameLabel
                                ,shopNameLabel
                                ,categoryLabel)
        imageViewWrapper.addSubviews(itemImage, soldOutView)
        
        imageViewWrapper.pin.top().horizontally().height(180)
        itemImage.pin.all()
        soldOutView.pin.all()
        
        itemNameLabel.pin.below(of: imageViewWrapper).horizontally().marginTop(12).height(19)
        shopNameLabel.pin.below(of: itemNameLabel).horizontally().marginTop(4).height(17)
//        categoryLabel.pin.below(of: shopNameLabel).horizontally().marginTop(4).height(17)
    }
    
    func configure(info: WithItemsInfo) {
        itemImage.setKF(urlString: info.imageUrl ?? "", placeHolder: .image_indicator) { [weak self] _ in
            guard let self else { return }
            self.layoutIfNeeded()
        }
            
        itemNameLabel.text = info.name ?? ""
        shopNameLabel.text = info.brandName ?? ""
//        categoryLabel.text = info.category?.categoryName ?? ""
        
        if isSoldOut(info.status ?? "") { isHiddenToggle() }
    }
    
    func isSoldOut(_ status: String) -> Bool {
        (status == "sold_out") ? true : false
    }
    
    func isHiddenToggle() {
        soldOutView.isHidden.toggle()
        // FIXME: - 인터렉션 막던지 alert 띄우기 의논해보기
        self.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemImage.image = nil
        self.itemImage.kf.cancelDownloadTask()
        self.soldOutView.isHidden = true
        bag = DisposeBag()
    }
}


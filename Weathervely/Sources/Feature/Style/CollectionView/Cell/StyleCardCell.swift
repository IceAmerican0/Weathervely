//
//  StyleCardCell.swift
//  Weatherbly
//
//  Created by Khai on 10/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then
import Kingfisher

public final class StyleCardCell: UICollectionViewCell {
    private var nameLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray100
    ).make(text: "이 옷은 어느 쇼핑몰에서?")
    
    private var imageViewWrapper = UIView().then {
        $0.layer.setShadow(
            CGSize(width: 4, height: 4),
            UIColor.dark12.cgColor, 1, 4
        )
    }
    
    private var imageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.setCornerRadius(12)
        $0.contentMode = .center
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
        
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        layer.masksToBounds = false
        
        contentView.flex.define {
            $0.addItem(imageViewWrapper).width(120).height(180).define {
                $0.addItem(imageView).grow(1)
            }
            $0.addItem(nameLabel).marginTop(12).width(120).height(17)
        }
    }
    
    func configure(info: ClosetInfo?) {
        guard let info else { return }
        nameLabel.text = info.closetName
        imageView.setKF(urlString: info.closetImageUrl, placeHolder: UIImage.image_indicator) { [weak self] _ in
            guard let self else { return }
            imageViewWrapper.layoutIfNeeded()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.imageView.contentMode = .center
        self.imageView.kf.cancelDownloadTask()
    }
}

//
//  StyleCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import DesignSystem
import UIKit

final class StyleCell: UICollectionViewCell {
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
    
    private var id = ""
    private var closetName = ""
    private var imageUrl = ""
    private var status = ""
    public var closetInfo = ClosetInfo(closetId: 0, closetName: "", closetImageUrl: "", closetStatus: "", closetSiteName: "", temperature: .init(tempId: 0, maxTemp: 0, minTemp: 0))
    
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
        
        contentView.flex.define {
            $0.addItem(imageViewWrapper).width(120).height(180).define {
                $0.addItem(imageView).grow(1)
            }
            $0.addItem(nameLabel).marginTop(12).width(120).height(17)
        }
    }
    
    func configure(info: ClosetInfo?) {
        guard let info else { return }
        let id = info.closetId
        let name = info.closetName
        let imageUrl = info.closetImageUrl
        let status = info.closetStatus
        let shopName = info.closetSiteName
        let temperature = info.temperature
        closetInfo = ClosetInfo(closetId: id, closetName: name, closetImageUrl: imageUrl, closetStatus: status, closetSiteName: shopName, temperature: temperature)
        nameLabel.text = name
        imageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] _ in
            guard let self else { return }
            imageViewWrapper.layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.imageView.contentMode = .center
        self.imageView.kf.cancelDownloadTask()
    }
}

//
//  StyleCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then
import Kingfisher

final class StyleCell: UICollectionViewCell {
    
    let imagePlaceHolder = UIImage.image_indicator.reDesign(size: CGSizeMake(56, 56))
    
    private var nameLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray100,
        alignment: .left
    ).make(text: "이 옷은 어느 쇼핑몰에서?")
    
    private var imageViewWrapper = UIView().then {
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var imageView = UIImageView().then {
        $0.image = UIImage.image_indicator.reDesign(size: CGSizeMake(56, 56))
        $0.contentMode = .scaleAspectFit
    }
    
    private var id = ""
    private var closetName = ""
    private var imageUrl = ""
    private var status = ""
    public var closetInfo = NewClosetInfo(closetId: 0, closetName: "", closetImageUrl: "", closetStatus: "", closetSiteName: "", temperature: .init(tempId: 0, maxTemp: 0, minTemp: 0))
    
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
        
        imageView.layer.masksToBounds = true
        imageView.setCornerRadius(12)
        
        contentView.flex.direction(.column).define {
            $0.addItem(imageViewWrapper).define {
                $0.addItem(imageView).height(180).alignSelf(.center)
            }
            $0.addItem(nameLabel).marginTop(12).width(120).height(17)
        }
    }
    
    func configure(info: NewClosetInfo?) {
        guard let info = info else { return }
        let id = info.closetId
        let name = info.closetName
        let imageUrl = info.closetImageUrl
        let status = info.closetStatus
        let shopName = info.closetSiteName
        let temperature = info.temperature
        closetInfo = NewClosetInfo(closetId: id, closetName: name, closetImageUrl: imageUrl, closetStatus: status, closetSiteName: shopName, temperature: temperature)
        nameLabel.text = name
        imageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] result in
            switch result {
            case .success:
                self?.imageView.pin.all()
                self?.imageView.contentMode = .scaleAspectFit
            case .failure:
                self?.imageView.pin.size(56)
                self?.imageView.contentMode = .center
            }
            self?.updateLayout(self?.imageView)
        }
    }
    
    private func updateLayout(_ view: UIView?) {
        view!.flex.markDirty()
        view!.layoutIfNeeded()
        view!.setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.imageView.kf.cancelDownloadTask()
    }
}

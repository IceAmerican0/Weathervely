//
//  StyleCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StyleCell: UICollectionViewCell {
    
    let imagePlaceHolder = UIImage.image_indicator.resized(to: CGSizeMake(56, 56))
    
    private var nameLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray100,
        alignment: .left
    ).make(text: "이 옷은 어느 쇼핑몰에서?")
    
    private var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var imageView = UIImageView().then {
        $0.image = UIImage.image_indicator
        $0.contentMode = .scaleAspectFit
    }
    
    private var id = ""
    private var closetName = ""
    private var imageUrl = ""
    private var status = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        layout()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.direction(.column).define {
            $0.addItem(imageViewWrapper).define {
                $0.addItem(imageView).width(120).height(180).alignSelf(.center)
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
        let tpyeId = temperature.tempId
        
        nameLabel.text = name
        imageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] result in
            switch result {
            case .success:
                self?.imageView.pin.all()
                self?.imageView.contentMode = .scaleAspectFit
            case .failure:
                self?.imageView.pin.all()
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
    }
}

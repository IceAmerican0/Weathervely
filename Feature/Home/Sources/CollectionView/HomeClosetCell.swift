//
//  HomeClosetCell.swift
//  Weatherbly
//
//  Created by Khai on 1/4/24.
//

import UIKit
import DesignSystem
import WVNetwork

public final class HomeClosetCell: UICollectionViewCell {
    let cloth = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .center
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cloth.image = nil
        cloth.kf.cancelDownloadTask()
        cloth.contentMode = .center
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    private func layout() {
        clipsToBounds = true
        layer.masksToBounds = false
        layer.setShadow(
            CGSize(width: 4, height: 4),
            UIColor.dark12.cgColor, 1, 4
        )
        
        contentView.layer.masksToBounds = true
        contentView.setCornerRadius(12)
        
        contentView.flex.define {
            $0.addItem(cloth).grow(1)
        }
    }
    
    public func configureCellState(imageURL: String) {
        cloth.setKF(urlString: imageURL, placeHolder: .image_indicator) { [weak self] _ in
            guard let self else { return }
            self.layoutIfNeeded()
        }
        
        layoutIfNeeded()
    }
}

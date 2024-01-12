//
//  HomeClosetCell.swift
//  Weatherbly
//
//  Created by Khai on 1/4/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import Kingfisher

public final class HomeClosetCell: UICollectionViewCell {
    
    let cloth = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
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
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.bounds.size.width = size.width
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
        self.setCornerRadius(12)
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func layout() {
        contentView.flex.define {
            $0.addItem(cloth).grow(1)
        }
    }
    
    func configureCellState(state: RecommendClosetInfo) {
        cloth.setKF(urlString: state.imageUrl)
        setNeedsLayout()
    }
}

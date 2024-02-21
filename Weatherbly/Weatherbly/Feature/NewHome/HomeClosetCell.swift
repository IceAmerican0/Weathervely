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
        setLayout()
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    func setLayout() {
        cloth.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        backgroundColor = .gray10
        setCornerRadius(12)
        layer.masksToBounds = true
        clipsToBounds = true
        
        contentView.flex.define {
            $0.addItem(cloth).grow(1)
        }
    }
    
    func configureCellState(state: NewClosetInfo) {
        if state.imageURL == "" {
            cloth.flex.width(158).height(158)
            cloth.image = .home_banner_01
        } else {
            cloth.setKF(urlString: state.imageURL)
        }
        
        cloth.flex.markDirty()
        setNeedsLayout()
    }
}

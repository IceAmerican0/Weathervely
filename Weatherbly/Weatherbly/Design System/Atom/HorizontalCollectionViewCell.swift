//
//  HorizontalCollectionViewCell.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class HorizontalCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = LabelMaker(font: UIFont.body_5_M).make("Detail TextDetail TextDetail TextDetail Text")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellLayout()
        cellAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func cellAttribute() {
        
        nameLabel.do {
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
        
        imageView.do {
            $0.tintColor = .green
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func cellLayout() {
        
        contentView.flex.width(120).height(209).define { flex in
            flex.addItem(imageView).height(180)
            flex.addItem(nameLabel).height(nameLabel.font.setLineHeight()).marginTop(12)
        }
        
    }

}

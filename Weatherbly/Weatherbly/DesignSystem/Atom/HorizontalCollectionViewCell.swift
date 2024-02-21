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
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    
    var nameLabel = LabelMaker(font: UIFont.body_5_M).make(text: "Detail TextDetail TextDetail TextDetail Text")
    
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
        
        imageView.do {
            $0.tintColor = .green
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.do {
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
    }
    
    func cellLayout() {
        
        contentView.flex.width(120).height(209).define { flex in
            flex.addItem(imageView).height(180)
            flex.addItem(nameLabel).height(nameLabel.font.setLineHeight()).marginTop(12)
        }
        
    }

}

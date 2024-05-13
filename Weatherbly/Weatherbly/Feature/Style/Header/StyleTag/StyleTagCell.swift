//
//  StyleTagCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/9/24.
//

import UIKit
import FlexLayout
import PinLayout

final class StyleTagCell: UICollectionViewCell {
    
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
//        padding: UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
    ).make(text: "#tag1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
        
        cellLayout()
    }
    
    private func configure() {
        
        contentView.do {
            $0.layer.cornerRadius = 14
            $0.backgroundColor = UIColor.gray10
        }
        
        tagLabel.do {
            $0.frame = bounds
            $0.numberOfLines = 1
            
        }
    }

    func cellLayout() {
        
        contentView.flex.define { flex in
            flex.addItem(tagLabel).grow(1)
        }
    }
    
}

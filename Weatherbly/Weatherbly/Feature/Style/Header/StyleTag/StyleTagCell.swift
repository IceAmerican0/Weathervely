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
    
    private var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center,
        padding: UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
    ).make(text: "#tag1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentViewConfigure()
        cellLayout()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustWidth)
    }
    
    private func contentViewConfigure() {
        contentView.layer.cornerRadius = 14
        contentView.backgroundColor = UIColor.gray10
    }
    
    func cellLayout() {
        contentView.flex.define { flex in
            flex.addItem(tagLabel)
            
        }
    }
}

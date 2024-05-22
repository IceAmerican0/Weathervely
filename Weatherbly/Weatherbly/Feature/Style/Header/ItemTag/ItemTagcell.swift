//
//  ItemTagcell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import FlexLayout
import PinLayout

final class ItemTagcell: UICollectionViewCell {
    
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#Item1")
    
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
        tagLabel.frame = bounds //  tagLabel이 부모 뷰를 완전히 덮도록 설정
        cellLayout()
    }
    
    private func configure() {
        
        contentView.do {
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray20.cgColor
        }
        
        tagLabel.do {
            $0.numberOfLines = 1
        }
    }

    func cellLayout() {
        
        contentView.addSubview(tagLabel)
        tagLabel.pin.all()
    }
    
}


//
//  TitleLabelReusableHeader.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/16/24.
//

import UIKit
import PinLayout
import FlexLayout

class TitleLabelReusableHeader: UICollectionReusableView {
    private let container = UIView()
    
    private var titleLabel = LabelMaker(
        font: UIFont.body_3_B
    ).make(text: "Title text")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.pin.all()
        container.flex.layout()
    }
    
    private func layout() {
        backgroundColor = .clear
        
        flex.addItem(container).define {
            $0.addItem(titleLabel)
        }
    }
    
    public func configure(font: UIFont? = nil, text: String? = nil) {
        if let font {
            titleLabel.font = font
        }
        if let text {
            titleLabel.text = text
        }
    }
    
}

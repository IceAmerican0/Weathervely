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
    
    private let container = UIView()
    var imageView = UIImageView()
    var detailLabel = LabelMaker(font: UIFont.body_5_M).make("Detail Text")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .yellow
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func layout() {
        self.backgroundColor = .gray10
        
        contentView.flex.define { flex in
            flex.addItem(container)
            
        }
        
    }
    
    func configureCellState() {
        
    }
}

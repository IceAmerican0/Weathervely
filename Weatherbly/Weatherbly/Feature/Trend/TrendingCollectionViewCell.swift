//
//  TrendingCollectionViewCell.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class TrendingCollectionViewCell: UICollectionViewCell {
    private let container = UIView()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        self.backgroundColor = .white
        contentView.flex.alignItems(.center).justifyContent(.center).define {
            $0.addItem(imageView).width(((UIScreen.main.bounds.width - 30) / 3) - 20).height(140)
        }
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.contentView.layer.shadowColor = CSColor._255_255_255_05.cgColor
        self.layer.setShadow(CGSize(width: 0, height: 4), CSColor.none.cgColor, 0.25, 7.5)
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    func configureCellState() {
        
    }
}

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
    private let imageView = UIImageView()
    private let textLabel = CSLabel(.regular, 11, "loading...")
    
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
        
    }
    
    func configureCellState() {
        
    }
}

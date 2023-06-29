//
//  ClosetCollectionViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/29.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class ClosetCollectionViewCell: UICollectionViewCell {
    
    private var clothImageView = UIImageView()
    private var clothImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
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
    
    func attribute() {
        
    }
    
    private func layout() {
        contentView.flex.addItem(contentView).alignSelf(.center).define { flex in
            flex.addItem(clothImageView)
            flex.addItem(clothImageSourceLabel)
        }
    }
    
}

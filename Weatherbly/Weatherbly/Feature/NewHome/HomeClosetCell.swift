//
//  HomeClosetCell.swift
//  Weatherbly
//
//  Created by Khai on 1/4/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public final class HomeClosetCell: UICollectionViewCell {
    
    let banner = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.define {
            $0.addItem(banner).size(158)
        }
    }
}

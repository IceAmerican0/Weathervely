//
//  RegionCollectionViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/12.
//

import UIKit

class RegionCollectionViewCell: UICollectionViewCell {
    
    var regionLabel = CSLabel(.regular, 20, "서울특별시 송파구 풍납1동")
    let rightArrowImageView = UIImageView().then {
        $0.setAssetsImage(AssetsImage.rightArrow)
    }
    
    private let labelWidth = UIScreen.main.bounds.width * 0.35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(regionLabel).marginTop(5).width(labelWidth).height(28)
            flex.addItem(rightArrowImageView).marginLeft(8).size(24)
        }
    }
}

//
//  EditRegionCollectionViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public final class EditRegionCollectionViewCell: UICollectionViewCell {
    
    private let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = false
        $0.clipsToBounds = false
    }
    
    private let regionLabel = LabelMaker(
        font: .body_1_M
    ).make().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let regionChecked = UIImageView().then {
        $0.image = .icon_region_check
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 68)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.define {
            $0.addItem(container).direction(.row).alignItems(.center).justifyContent(.spaceBetween).grow(1).define {
                $0.addItem(regionLabel).marginLeft(20).marginRight(16).height(21).grow(1).shrink(1)
                $0.addItem(regionChecked).marginRight(20).size(20).display(.none)
            }
        }
        
        backgroundColor = .clear
    }
    
    public func configureCellState(region: String, row: Int) {
        regionLabel.text = region
        
        if row == 0 {
            container.layer.borderColor = UIColor.violet600.cgColor
            regionChecked.flex.display(.flex)
        } else {
            container.layer.borderColor = UIColor.violet150.cgColor
            regionChecked.flex.display(.none)
        }
        
        container.flex.markDirty()
    }
}

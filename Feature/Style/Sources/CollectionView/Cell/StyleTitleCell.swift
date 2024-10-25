//
//  StyleTitleCell.swift
//  Weatherbly
//
//  Created by Khai on 10/1/24.
//

import DesignSystem
import ResourcePackage
import UIKit
import FlexLayout
import PinLayout
import Then

public final class StyleTitleCell: UICollectionViewCell {
    private var titleLabel = LabelMaker(
        font: UIFont.title_3_B
    ).make(text: "#Type1").then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.define {
            $0.addItem(titleLabel).marginTop(16)
        }
    }
    
    public func configureCellState(text: String) {
        titleLabel.text = "#\(text)"
        titleLabel.flex.markDirty()
    }
}

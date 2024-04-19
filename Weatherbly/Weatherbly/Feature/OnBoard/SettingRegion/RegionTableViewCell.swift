//
//  RegionTableViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/12.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout
import Then

public final class RegionTableViewCell: UITableViewCell {
    public var regionLabel = LabelMaker(
        font: .body_3_M
    ).make()
    
    var arrow = UIImageView().then {
        $0.image = .rightArrow_gray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
            flex.addItem(regionLabel).marginLeft(8).grow(1).shrink(1)
            flex.addItem(arrow).marginRight(8).size(16)
        }
    }
    
    func configureCellState(_ region: String) {
        regionLabel.text = region
    }
}

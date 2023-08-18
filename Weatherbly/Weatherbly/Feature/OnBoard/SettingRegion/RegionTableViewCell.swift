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

public final class RegionTableViewCell: UITableViewCell {
    
    var regionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
        $0.adjustsFontSizeToFitWidth = false
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 0
    }
    
    let rightArrowImageView = UIButton().then {
        $0.setImage(AssetsImage.rightArrow.image, for: .normal)
    }
    
    var disposeBag = DisposeBag()
    
    private let labelWidth = UIScreen.main.bounds.width * 0.75
    
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
        contentView.flex.direction(.row).justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(regionLabel).width(labelWidth).height(28)
            flex.addItem(rightArrowImageView).marginLeft(8).size(24)
        }
    }
    
    func configureCellState(_ region: String) {
        regionLabel.text = region
    }
}

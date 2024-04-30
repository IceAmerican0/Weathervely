//
//  FilterListCell.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import PinLayout
import FlexLayout
import Then
import RxCocoa

public final class ItemFilterCell: UICollectionViewCell {
    private lazy var listButton = FilterButton(filterType: .item).then {
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        setLayout()
        contentView.flex.layout(mode: .adjustWidth)
        return contentView.frame.size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    public func configureCellState(state: FilterStyleListInfo) {
        /// 셀 크기 재정의
        listButton.flex.markDirty()
        setLayout()
    }
}

// MARK: UI Settings
private extension ItemFilterCell {
    func setLayout() {
        listButton.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.define {
            $0.addItem(listButton).grow(1)
        }
    }
}

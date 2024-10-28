//
//  StyleFilterCell.swift
//  Weatherbly
//
//  Created by Khai on 10/2/24.
//

import DesignSystem
import Network
import UIKit

public final class StyleFilterCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    public var listButton = FilterButton(filterType: .style).then {
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    var buttonTap: Driver<Void> {
        self.listButton.rx.tap.asDriver()
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        listButton.isSelected = false
    }
    
    public func configureCellState(state: CategoryInfo, list: [String] = []) {
        listButton.titleAttribute(title: state.name)
        
        if list.contains("\(state.id)") {
            listButton.isSelected = true
        }
        
        /// 셀 크기 재정의
        listButton.flex.markDirty()
        setLayout()
    }
}

// MARK: UI Settings
private extension StyleFilterCell {
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

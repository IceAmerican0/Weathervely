//
//  HomeStyleFilterCell.swift
//  Weatherbly
//
//  Created by Khai on 4/26/24.
//

import UIKit
import PinLayout
import FlexLayout
import Then
import RxSwift
import RxCocoa

public final class HomeStyleFilterCell: UICollectionViewCell {
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
    }
    
    public func configureCellState(state: StyleTypeInfo) {
        listButton.titleAttribute(title: state.name)
        
        UserDefaultManager.shared.homeStyleFilterList.value.forEach { id in
            listButton.isSelected = id == state.id
        }
        
        /// 셀 크기 재정의
        listButton.flex.markDirty()
        setLayout()
    }
}

// MARK: UI Settings
private extension HomeStyleFilterCell {
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

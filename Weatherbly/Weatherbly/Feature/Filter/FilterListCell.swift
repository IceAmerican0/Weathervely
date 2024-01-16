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

public struct FilterListCellState {
    let title: String
    let selectable: Bool
    let selected: Bool
}

final class FilterListCell: UICollectionViewCell {
    private let container = UIView().then {
        $0.layer.cornerRadius = 30
        $0.layer.borderWidth = 2
        $0.accessibilityTraits = .button
    }
    
    private lazy var listButton = UIButton().then {
        $0.titleLabel?.font = .body_1_B
        $0.setTitleColor(.violet900, for: .normal)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        bounds.size.width = size.width
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        listButton.pin.all()
        container.pin.all()
        contentView.flex.layout()
    }
    
    public func configureCellState(state: FilterListCellState) {
        listButton.setTitle("\(state.title)", for: .normal)
        
        /// 아이템 없을시 선택불가
        if !state.selectable {
            buttonSetting(
                backgroundColor: .gray20,
                borderColor: .gray20,
                textColor: .gray50
            )
            listButton.isUserInteractionEnabled = false
            return
        }
        
        /// 필터 선택 여부
        if state.selected {
            buttonSetting(
                backgroundColor: .violet600,
                borderColor: .violet600,
                textColor: .white
            )
        } else {
            buttonSetting(
                backgroundColor: .white,
                borderColor: .violet200,
                textColor: .violet500
            )
        }
        
        listButton.isUserInteractionEnabled = true
    }
    
    private func buttonSetting(
        backgroundColor: UIColor,
        borderColor: UIColor,
        textColor: UIColor
    ) {
        container.backgroundColor = backgroundColor
        container.layer.borderColor = borderColor.cgColor
        listButton.setTitleColor(textColor, for: .normal)
    }
}

private extension FilterListCell {
    func layout() {
        contentView.flex.define {
            $0.addItem(container).grow(1).define {
                $0.addItem(listButton).marginHorizontal(14).grow(1)
            }
        }
    }
}

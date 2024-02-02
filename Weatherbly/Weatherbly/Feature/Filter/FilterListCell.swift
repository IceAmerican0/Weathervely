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
    private let listButton = UIButton().then {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    public func configureCellState(state: FilterListCellState) {
        /// 셀 크기 재정의
        listButton.flex.markDirty()
        setLayout()
        
        /// 아이템 없을시 선택불가
        if !state.selectable {
            buttonSetting(
                text: state.title,
                backgroundColor: .gray20,
                borderColor: .gray20,
                textColor: .gray50
            )
            listButton.isUserInteractionEnabled = true
            return
        }
        
        /// 필터 선택 여부
        if state.selected {
            buttonSetting(
                text: state.title,
                backgroundColor: .violet600,
                borderColor: .violet600,
                textColor: .white
            )
        } else {
            buttonSetting(
                text: state.title,
                backgroundColor: .white,
                borderColor: .violet200,
                textColor: .violet900
            )
        }
        
        listButton.isUserInteractionEnabled = false
    }
}

// MARK: UI Settings
private extension FilterListCell {
    func setLayout() {
        listButton.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.define {
            $0.addItem(listButton).grow(1)
        }
    }
    
    func buttonConfiguration() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 14, bottom: 8, trailing: 14)
        config.background.strokeWidth = 2
        config.background.cornerRadius = 30
        listButton.configuration = config
    }
    
    func buttonSetting(
        text: String,
        backgroundColor: UIColor,
        borderColor: UIColor,
        textColor: UIColor
    ) {
        buttonConfiguration()
        let attributed: [NSAttributedString.Key: Any] = [
            .font: UIFont.body_1_B,
            .foregroundColor: textColor
        ]
        let attString = NSAttributedString(string: text, attributes: attributed)
        listButton.setAttributedTitle(attString, for: .normal)
        listButton.configuration?.baseBackgroundColor = backgroundColor
        listButton.configuration?.background.strokeColor = borderColor
    }
}

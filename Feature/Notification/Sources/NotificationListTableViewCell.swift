//
//  NotificationListTableViewCell.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import DesignSystem
import UIUtil
import ResourcePackage
import Network
import UIKit
import FlexLayout
import PinLayout
import Then

public final class NotificationListTableViewCell: UITableViewCell {
    private let icon = UIImageView()
    
    private var titleLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .kiwiGray90
    ).make()
    
    private var commentLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .kiwiGray700
    ).make()
    
    private var timeLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .kiwiGray90
    ).make()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    public func configureCellState(state: NotificationEntity) {
        icon.image = switch state.title {
            case "날씨와 옷차림": .alarm_codi
            case "찜": .alarm_favorites
            case "웨더블리 꿀팁": .alarm_tip
            default: .alarm_codi
        }
        
        titleLabel.text = state.title
        timeLabel.text = state.date.isoToDate.timePassed()
        commentLabel.text = state.content
        
        titleLabel.flex.markDirty()
        commentLabel.flex.markDirty()
        timeLabel.flex.markDirty()
    }
}

private extension NotificationListTableViewCell {
    private func layout() {
        backgroundColor = .clear
        
        contentView.flex.define {
            $0.addItem().direction(.row).justifyContent(.spaceBetween).marginVertical(19).marginHorizontal(20).grow(1).define {
                $0.addItem(icon).size(40)
                $0.addItem().marginHorizontal(20).grow(1).shrink(1).define {
                    $0.addItem(titleLabel)
                    $0.addItem(commentLabel).marginTop(4)
                }
                $0.addItem(timeLabel).height(17)
            }
        }
    }
}

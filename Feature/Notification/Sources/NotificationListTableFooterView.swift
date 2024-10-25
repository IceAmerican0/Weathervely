//
//  NotificationListTableFooterView.swift
//  Weatherbly
//
//  Created by Khai on 5/21/24.
//

import DesignSystem
import UIUtil
import ResourcePackage
import UIKit
import PinLayout
import FlexLayout
import Then

public final class NotificationListTableFooterView: UITableViewHeaderFooterView {
    private let container = UIView().then {
        $0.backgroundColor = .gray10
        $0.setCornerRadius(12)
    }
    
    private var infoLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .gray70
    ).make(text: "30일이 지난 알림은 자동으로 삭제돼요.")
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        contentView.backgroundColor = .clear
        contentView.flex.define {
            $0.addItem(container).marginTop(17).marginHorizontal(20).height(40).alignSelf(.stretch).define {
                $0.addItem(infoLabel).marginLeft(20).grow(1)
            }
        }
    }
}

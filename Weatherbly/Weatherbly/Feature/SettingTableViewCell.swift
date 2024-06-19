//
//  SettingTableViewCell.swift
//  Weatherbly
//
//  Created by Khai on 2/6/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxCocoa
import RxSwift

public enum SettingMenuTitle: String, CaseIterable {
    case inquiry = "문의하기"
    case policy = "약관 및 정책"
    case versionInfo = "버전정보"
}

public final class SettingTableViewCell: UITableViewCell {
    private let titleLabel = LabelMaker(
        font: .body_3_M
    ).make()
    
    private let toggleSwitch = CSSwitch().then {
        $0.isSelected = false
    }
    
    private let naviButton = UIImageView().then {
        $0.image = .commontab
    }
    
    private let version = LabelMaker(
        font: .body_3_M,
        fontColor: .gray50,
        alignment: .right
    ).make()
    
    var toggleTap: Driver<Bool>?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    public func configureCellState(state: SettingMenuTitle) {
        self.selectionStyle = .none
        titleLabel.text = state.rawValue
        
        switch state {
        case .versionInfo:
            toggleSwitch.isHidden = true
            version.flex.display(.flex)
            version.text = "\(Constants.bundleShortVersion)"
        case .inquiry, .policy:
            toggleSwitch.isHidden = true
            naviButton.flex.display(.flex)
        }
    }
}

private extension SettingTableViewCell {
    private func setLayout() {
        contentView.pin.horizontally(20).vertically()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.direction(.row).alignItems(.center).justifyContent(.spaceBetween).define {
            $0.addItem(titleLabel).marginLeft(8)
            $0.addItem(toggleSwitch).marginRight(8).display(.none)
            $0.addItem(naviButton).marginRight(8).size(16).display(.none)
            $0.addItem(version).marginRight(8).display(.none)
        }
    }
}

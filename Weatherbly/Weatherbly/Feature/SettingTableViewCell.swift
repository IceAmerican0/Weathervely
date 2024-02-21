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
    case noti = "알림 설정"
    case share = "앱 공유하기"
    case inquiry = "문의하기"
    case policy = "약관 및 정책"
    case openSource = "오픈소스 라이브러리"
    case versionInfo = "버전정보"
    case logout = "로그아웃"
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
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        setLayout()
        return CGSize(width: contentView.frame.width, height: 51)
    }
    
    public func configureCellState(state: SettingMenuTitle) {
        self.selectionStyle = .none
        titleLabel.text = state.rawValue
        titleLabel.flex.markDirty()
        
        switch state {
        case .noti:
            toggleSwitch.flex.display(.flex)
            toggleSwitch.flex.markDirty()
        case .versionInfo:
            toggleSwitch.isHidden = true
            version.flex.display(.flex)
            version.text = "\(Constants.bundleDisplayName) Ver \(Constants.bundleShortVersion)"
            version.flex.markDirty()
        case .share, .inquiry, .policy, .openSource:
            toggleSwitch.isHidden = true
            naviButton.flex.display(.flex)
            naviButton.flex.markDirty()
        case .logout:
            toggleSwitch.isHidden = true
        }
        setNeedsLayout()
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

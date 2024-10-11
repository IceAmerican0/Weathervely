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
import RxGesture

public enum SettingMenuTitle: String, CaseIterable {
    case notification = "알림 설정"
    case inquiry = "문의하기"
    case policy = "약관 및 정책"
    case versionInfo = "버전정보"
}

public final class SettingTableViewCell: UITableViewCell {
    var bag = DisposeBag()
    
    private let titleLabel = LabelMaker(
        font: .body_3_M
    ).make()
    
    private let toggleSwitch = CSSwitch().then {
        $0.isSelected = UserDefaultManager.shared.pushAgreement
    }
    
    private let pushSetting = LabelMaker(
        font: .body_3_B,
        fontColor: .violet900,
        alignment: .right
    ).make(text: "권한 설정하기")
    
    private let naviButton = UIImageView().then {
        $0.image = .commontab
    }
    
    private let version = LabelMaker(
        font: .body_3_M,
        fontColor: .gray50,
        alignment: .right
    ).make(text: "\(Constants.bundleShortVersion)")
    
    var toggleTap: Driver<Bool> {
        toggleSwitch.isSelectedRelay.asDriver(onErrorJustReturn: false)
    }
    
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public func configureCellState(state: SettingMenuTitle) {
        self.selectionStyle = .none
        titleLabel.text = state.rawValue
        titleLabel.flex.markDirty()
        
        switch state {
        case .notification:
            version.flex.display(.none)
            switchState()
        case .versionInfo:
            toggleSwitch.flex.display(.none)
            pushSetting.flex.display(.none)
            version.flex.display(.flex)
        case .inquiry, .policy:
            naviButton.flex.display(.flex)
        }
    }
}

private extension SettingTableViewCell {
    func setLayout() {
        contentView.pin.horizontally(20).vertically()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.direction(.row).alignItems(.center).justifyContent(.spaceBetween).define {
            $0.addItem(titleLabel).marginLeft(8)
            $0.addItem(toggleSwitch).marginRight(8).display(.none)
            $0.addItem(pushSetting).marginRight(8).display(.none)
            $0.addItem(naviButton).marginRight(8).size(16).display(.none)
            $0.addItem(version).marginRight(8).display(.none)
        }
    }
    
    func switchState() {
        Task {
            let authority = await UserNotificationManager.shared.checkAuthorization()
            
            if authority {
                toggleSwitch.flex.display(.flex)
                pushSetting.flex.display(.none)
            } else {
                toggleSwitch.flex.display(.none)
                pushSetting.flex.display(.flex)
                
                pushSetting.rx.tapGesture()
                    .when(.recognized)
                    .bind(with: self) { _, _ in
                        UserNotificationManager.shared.toPushSetting()
                    }.disposed(by: bag)
            }
            contentView.flex.layout()
        }
    }
}

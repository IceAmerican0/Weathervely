//
//  SettingCollectionViewCell.swift
//  Weatherbly
//
//  Created by Khai on 2/6/24.
//

import UIKit
import PinLayout
import FlexLayout
import Then
import RxSwift

public enum ProfileMenuTitle: CaseIterable {
    /// 동네
    case region
    /// 찜
    case wishList
    /// 체감온도
    case sensoryTemp
    
    var title: String {
        switch self {
        case .region:      "동네 추가"
        case .wishList:    "찜"
        case .sensoryTemp: "체감온도"
        }
    }
    
    var image: UIImage {
        switch self {
        case .region:      UIImage.icon_plusL
        case .wishList:    UIImage.icon_favorites
        case .sensoryTemp: UIImage.icon_temperature
        }
    }
}

public final class SettingCollectionViewCell: UICollectionViewCell {
    private let titleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = LabelMaker(
        font: .body_5_M
    ).make()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    public func configureCellState(state: ProfileMenuTitle) {
        titleImage.image = state.image
        titleLabel.text = state.title
    }
}

private extension SettingCollectionViewCell {
    func layout() {
        setCornerRadius(16)
        clipsToBounds = true
        backgroundColor = .violet50
        
        contentView.flex.alignItems(.center).define {
            $0.addItem(titleImage).marginTop(16).size(46)
            $0.addItem(titleLabel).marginTop(11)
        }
    }
}

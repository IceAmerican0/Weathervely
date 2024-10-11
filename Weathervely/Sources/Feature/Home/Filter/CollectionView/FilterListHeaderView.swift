//
//  FilterListHeaderView.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public final class FilterListHeaderView: UICollectionReusableView {
    private let container = UIView()
    
    private let category = LabelMaker(
        font: .body_3_M,
        fontColor: .gray80
    ).make()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        container.pin.all()
        container.flex.layout()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        flex.layout()
        return CGSize(width: size.width, height: 19)
    }
    
    public func configureViewState(title: String) {
        category.text = title
        category.flex.markDirty()
    }
}

extension FilterListHeaderView {
    func layout() {
        backgroundColor = .white
        
        flex.addItem(container).direction(.row).alignItems(.center).define {
            $0.addItem(category).grow(1)
        }
    }
}

//
//  TitleLabelReusableHeader.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/16/24.
//

import UIKit
import PinLayout
import FlexLayout

class TitleLabelReusableHeader: UICollectionReusableView {

    private let labelWrapper = UIView().then {
        $0.backgroundColor = .white
    }
    private var reusableLabel = LabelMaker(
        font: UIFont.title_3_B
    ).make(text: "Title text")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        self.addSubview(labelWrapper)
        labelWrapper.addSubview(reusableLabel)
        labelWrapper.pin.height(53).all() // height = 라벨 높이 + 윗 섹션거리 + item Top과의 거리
        reusableLabel.pin.height(reusableLabel.font.setLineHeight()).left().right().bottom()
    }
    
    public func configure(font: UIFont, text: String) {
        reusableLabel.font = font
        reusableLabel.text = text
    }
    
}

//
//  DiffTempDecoHeader.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/25/24.
//

import Foundation
import UIKit

final class DiffTempDecoHeader: UICollectionReusableView {
    
    private var titleLabel = LabelMaker(
        font: UIFont.title_1_B,
        fontColor: UIColor.red900,
        alignment: .left
    ).make(text: "더 따뜻한 코디")
    
    private var descriptLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray80,
        alignment: .left
    ).make(text: "현재 코디에서 더 따뜻한 코디를 추천드려요")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        self.flex.layout()
    }
    
    private func layout() {
        self.flex.define {
            $0.addItem(titleLabel).height(titleLabel.font.setLineHeight()).marginTop(30.5)
            $0.addItem(descriptLabel).height(descriptLabel.font.setLineHeight()).marginTop(9)
        }
    }
    
    public func configure(_ title: String, _ description: String) {
        titleLabel.text = title
        descriptLabel.text = description
    }
}

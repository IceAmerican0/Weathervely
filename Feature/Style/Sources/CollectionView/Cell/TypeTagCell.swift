//
//  StyleTagCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/9/24.
//

import DesignSystem
import UIKit
import RxSwift

public final class TypeTagCell: UICollectionViewCell {
    public var bag = DisposeBag()
    
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        alignment: .center
    ).make(text: "#tag").then {
        $0.numberOfLines = 1
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    private func setLayout() {
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustWidth)
    }
    
    private func layout() {
        contentView.do {
            $0.layer.cornerRadius = 14
            $0.backgroundColor = UIColor.gray10
        }
        
        contentView.flex.height(29).define {
            $0.addItem(tagLabel).marginHorizontal(14).marginVertical(6)
        }
    }
    
    public func configureCellState(text: String) {
        tagLabel.text = "#\(text)"
        tagLabel.flex.markDirty()
        setLayout()
    }
}

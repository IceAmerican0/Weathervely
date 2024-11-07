//
//  NoItemCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/21/24.
//

import DesignSystem
import UIKit
import FlexLayout

public final class NoItemCell: UICollectionViewCell {
    
    let contentWrapper = UIView()
    
    let noItemImage = UIImageView().then {
        $0.image = UIImage.search_empty.reDesign(size: CGSize(width: 48, height: 48))
        $0.contentMode = .center
    }
    
    let noitemLabel = LabelMaker(
        font: UIFont.body_5_M,
        fontColor: UIColor.gray50
    ).make(text: "조건에 맞는 코디가 없어요")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.flex.define {
            $0.addItem(contentWrapper).width(50%).alignItems(.center).define {
                $0.addItem(noItemImage).size(48).alignSelf(.center)
                $0.addItem(noitemLabel).alignSelf(.center)
            }
        }
    }
}

//
//  EditRegionCollectionViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public struct EditRegionCellState {
    let region: String
    let count: Int
}

public final class EditRegionCollectionViewCell: UICollectionViewCell {
    
    private let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.violet150.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = false
        $0.clipsToBounds = false
    }
    
    public var regionLabel = LabelMaker(
        font: .body_1_M
    ).make().then {
        $0.lineBreakMode = .byTruncatingTail
    }
    
    public let button = NewCSButton(.compact, style: .violet600).then {
        $0.setTitle("편집", for: .normal)
    }
    
    public var buttonTap: Driver<Void> {
        self.button.rx.tap.asDriver()
    }
    
    var bag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 68)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        button.resetState()
    }
    
    private func layout() {
        contentView.flex.define {
            $0.addItem(container).direction(.row).alignItems(.center).justifyContent(.spaceBetween).grow(1).define {
                $0.addItem(regionLabel).marginHorizontal(20).height(21).grow(1).shrink(1)
                $0.addItem(button).marginRight(20).width(53).height(24)
            }
        }
        
        backgroundColor = .clear
    }
    
    public func configureCellState(_ cellState: EditRegionCellState) {
        regionLabel.text = cellState.region
    }
}

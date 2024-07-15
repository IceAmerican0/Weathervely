//
//  HomeForecastSectionCell.swift
//  Weatherbly
//
//  Created by Khai on 7/15/24.
//

import UIKit
import FlexLayout
import PinLayout

public final class HomeForecastSectionCell: UICollectionViewCell {
    private let forecastView = HomeForecastSectionView()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        contentView.flex.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.flex.define {
            $0.addItem(forecastView).grow(1)
        }
    }
    
    public func configureCellState(state: [HomeForecastInfo]) {
        forecastView.configureCellState(state: state)
    }
}

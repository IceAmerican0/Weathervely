//
//  TenDaysForecastTableViewCell.swift
//  Weatherbly
//
//  Created by Khai on 1/30/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public final class TenDaysForecastTableViewCell: UITableViewCell {
    private let dateLabel = LabelMaker(
        font: .body_3_B,
        fontColor: .white
    ).make(text: "")
    
    private let weatherAM = UIImageView()
    
    private let weatherPM = UIImageView()
    
    private let minTempLabel = LabelMaker(
        font: .body_1_M,
        fontColor: .white
    ).make()
    
    private let maxTempLabel = LabelMaker(
        font: .body_1_M,
        fontColor: .white
    ).make()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    public func configureCellState(state: TenDayForecastInfo) {
        dateLabel.text = state.date
        minTempLabel.text = "\(state.minTemp)°"
        maxTempLabel.text = "\(state.maxTemp)°"
    }
}

private extension TenDaysForecastTableViewCell {
    private func layout() {
        backgroundColor = .clear
        
        contentView.flex.direction(.row).justifyContent(.center).define {
            $0.addItem(dateLabel).width(60)
            $0.addItem(weatherAM).width(44).height(32)
            $0.addItem(weatherPM).marginLeft(12).width(44).height(32)
            $0.addItem(minTempLabel)
            $0.addItem(maxTempLabel).marginLeft(20)
        }
    }
}

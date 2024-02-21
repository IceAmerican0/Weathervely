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
        contentView.pin.vertically().horizontally(24)
        contentView.flex.layout()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.flex.layout()
        return CGSize(width: contentView.frame.width, height: 49)
    }
    
    public func configureCellState(state: TenDayForecastInfo) {
        dateLabel.text = state.date
        minTempLabel.text = "\(state.minTemp)°"
        maxTempLabel.text = "\(state.maxTemp)°"
        
        let (_, AMImage) = setWeatherUI(
            weather: state.weatherAM,
            time: "오전"
        )
        let (_, PMImage) = setWeatherUI(
            weather: state.weatherPM,
            time: "오후"
        )
        weatherAM.image = AMImage
        weatherPM.image = PMImage
    }
}

private extension TenDaysForecastTableViewCell {
    private func layout() {
        backgroundColor = .clear
        
        contentView.flex.direction(.row).justifyContent(.spaceBetween).alignItems(.center).define {
            $0.addItem(dateLabel).width(60)
            $0.addItem().direction(.row).define { mid in
                mid.addItem(weatherAM).width(44).height(32)
                mid.addItem(weatherPM).marginLeft(12).width(44).height(32)
            }
            $0.addItem().direction(.row).define { end in
                end.addItem(minTempLabel)
                end.addItem(maxTempLabel).marginLeft(20)
            }
        }
    }
}

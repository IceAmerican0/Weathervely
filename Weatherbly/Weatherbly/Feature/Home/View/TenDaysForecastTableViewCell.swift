//
//  TenDaysForecastTableViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/05.
//

import UIKit
import FlexLayout
import PinLayout

class TenDaysForecastTableViewCell: UITableViewCell {
    
    let dateView = UIView()
    var dayOfWeekLabel = CSLabel(.regular, 16, "오늘")
    var dateLabel = CSLabel(.regular, 14, "7.5")
    
    let imageWrapper = UIView()
    let amWeatherImageView = UIImageView()
    let pmWeatherImageView = UIImageView()
    
    let leftRainPosLabel = UILabel()
    let rightRainPosLabel = UILabel()
    
    var temperatureLabel = CSLabel(.regular, 16, "20℃ / 30℃")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func attribute() {
        temperatureLabel.do {
            $0.textAlignment = .right
            $0.numberOfLines = 0
        }
        
        dayOfWeekLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        dateLabel.do {
            $0.font = UIFont.systemFont(ofSize: 14)
        }

        leftRainPosLabel.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CSColor._217_217_217.cgColor
            $0.attributedText = NSMutableAttributedString().medium("100%", 12, CSColor._97_97_97)
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.layer.cornerRadius = 3
        }
        
        rightRainPosLabel.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CSColor._217_217_217.cgColor
            $0.attributedText = NSMutableAttributedString().medium("100%", 12, CSColor._97_97_97)
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.layer.cornerRadius = 3
        }
    }
    
    
    private func layout() {
        contentView.flex.direction(.row)
            .justifyContent(.spaceAround)
            .paddingRight(30)
            .define { flex in
                flex.addItem(dateView).marginHorizontal(26).height(60).marginRight(12%).define { flex in
                    flex.addItem(dayOfWeekLabel).marginTop(13).width(110%).height(16)
                    flex.addItem(dateLabel).marginTop(5).width(110%).height(10)
                }
                
                flex.addItem(imageWrapper).direction(.row).marginRight(15).define { flex in
                    flex.addItem(leftRainPosLabel).width(37).height(20).marginRight(8).alignSelf(.center)
                    flex.addItem(amWeatherImageView).size(37).alignSelf(.center)
                    flex.addItem(pmWeatherImageView).marginLeft(5).size(37).alignSelf(.center)
                    flex.addItem(rightRainPosLabel).width(37).height(20).marginLeft(8).alignSelf(.center)
                }
                
                flex.addItem(temperatureLabel).width(30%)
                
                
            }
    }
    
    func isRainPosLabelHidden(_ amRainPos: Int, _ pmRainPos: Int) {
        if amRainPos < 40 {
            leftRainPosLabel.isHidden = true
        }
        
        if pmRainPos < 40 {
            rightRainPosLabel.isHidden = true
        }
    }
}

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
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func attribute() {
        
        self.do {
            $0.backgroundColor = UIColor(r: 250, g: 250, b: 250, a: 1)
        }
        
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
        
        amWeatherImageView.do {
            $0.setShadow(CGSize(width: 0, height: 2), CSColor._0__03.cgColor, 1, 2)
        }
        pmWeatherImageView.do {
            $0.setShadow(CGSize(width: 0, height: 2), CSColor._0__03.cgColor, 1, 2)
        }
    }
    
    
    private func layout() {
        contentView.flex.direction(.row)
            .alignItems(.center)
            .justifyContent(.center)
            .define { flex in
                flex.addItem(dateView).height(60).define { flex in
                    flex.addItem(dayOfWeekLabel).marginTop(13).width(29).height(16)
                    flex.addItem(dateLabel).marginTop(5).width(30).height(10)
                }
                
                flex.addItem(leftRainPosLabel).marginLeft(15.5).width(37).height(20)
                flex.addItem(amWeatherImageView).marginLeft(11).size(37)
                flex.addItem(pmWeatherImageView).marginLeft(5).size(37)
                flex.addItem(rightRainPosLabel).marginLeft(11).width(37).height(20)
                
                flex.addItem(temperatureLabel).marginLeft(3).width(28%)
            }
    }
    
    func isRainPosLabelHidden(_ amRainPos: Int, _ pmRainPos: Int) {
        if amRainPos < 40 {
            leftRainPosLabel.isHidden = true
            leftRainPosLabel.font = UIFont.systemFont(ofSize: 12)
        }
        
        if pmRainPos < 40 {
            rightRainPosLabel.isHidden = true
            rightRainPosLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
}

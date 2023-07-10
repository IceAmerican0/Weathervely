//
//  TenDaysForecastTableViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/05.
//

import UIKit

class TenDaysForecastTableViewCell: UITableViewCell {
    
    let dateView = UIView()
    var dayOfWeekLabel = CSLabel(.regular, 16, "오늘")
    var dateLabel = CSLabel(.regular, 14, "7.5")
    
    let amWeatherImageView = UIImageView()
    let pmWeatherImageView = UIImageView()
    
    var temperatureLabel = CSLabel(.regular, 16, "20℃ / 30℃")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(dateView).marginLeft(26).height(60).define { flex in
                flex.addItem(dayOfWeekLabel).marginTop(13).width(29).height(16)
                flex.addItem(dateLabel).marginTop(5).width(29).height(10)
            }
            flex.addItem(amWeatherImageView).marginLeft(63).size(30)
            flex.addItem(pmWeatherImageView).marginLeft(5).size(30)
            flex.addItem(temperatureLabel).marginLeft(39)
        }
    }
}

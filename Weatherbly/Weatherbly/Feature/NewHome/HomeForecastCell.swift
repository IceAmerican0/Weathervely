//
//  HomeForecastCell.swift
//  Weatherbly
//
//  Created by Khai on 1/2/24.
//

import UIKit
import PinLayout
import FlexLayout
import Then

public struct HomeForecastCellState {
    public let isDayTime: Bool
    public let mainTemp: String
    public let minTemp: String
    public let maxTemp: String
    public let weather: String
    public let comment: String
}

public final class HomeForecastCell: UICollectionViewCell {
    private let container = UIView()
    
    private let mainTempLabel = LabelMaker(
        font: .heading_1_UL,
        fontColor: .white
    ).make()
    
    private let sensoryTempLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .white
    ).make(text: "체감온도")
    
    private let dailyTempLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .white
    ).make()
    
    private let weatherImage = UIImageView()
    
    private let commentLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .white
    ).make().then {
        $0.setCornerRadius(10.5)
        $0.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        bounds.size.width = size.width
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
        self.setCornerRadius(14)
    }
    
    public func configureCellState(state: HomeForecastCellState) {
        mainTempLabel.text = "\(state.mainTemp)°"
        dailyTempLabel.text = "\(state.minTemp)° / \(state.maxTemp)°"
        commentLabel.text = state.comment
        
        let (color, image) = setWeather(weather: state.weather, isDayTime: state.isDayTime)
        self.backgroundColor = color
        weatherImage.image = image
    }
}

private extension HomeForecastCell {
    func layout() {
        contentView.flex.alignItems(.center).define {
            $0.addItem().direction(.row).justifyContent(.spaceBetween).marginTop(27).define {
                $0.addItem(mainTempLabel).marginLeft(20).size(68)
                $0.addItem().marginLeft(18).grow(1).define { middle in
                    middle.addItem(sensoryTempLabel)
                    middle.addItem(dailyTempLabel).marginTop(5)
                }
                $0.addItem(weatherImage).marginRight(20).width(110).height(74)
            }
            $0.addItem(commentLabel).marginTop(4).marginHorizontal(20).grow(1)
        }
    }
    
    func setWeather(weather: String, isDayTime: Bool) -> (UIColor, UIImage) {
        switch weather {
        case "맑음": isDayTime ?
            (UIColor.sky600, UIImage.sunny_am) :
            (UIColor.sky600, UIImage.sunny_pm)
        case "흐림": (UIColor.sky600, UIImage.cloudy)
        case "구름많음": isDayTime ?
            (UIColor.sky600, UIImage.clouds_am) :
            (UIColor.sky600, UIImage.clouds_pm)
        case "비": (UIColor.sky600, UIImage.rainy)
        case "눈비": (UIColor.sky600, UIImage.snowyRainy)
        case "눈": (UIColor.sky600, UIImage.snowy)
        case "바람": (UIColor.sky600, UIImage.windy)
        default: (UIColor.sky600, UIImage.sunny_am)
        }
    }
}

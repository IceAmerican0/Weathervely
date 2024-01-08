//
//  HomeForecastCell.swift
//  Weatherbly
//
//  Created by Khai on 1/2/24.
//

import UIKit
import PinLayout
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
    
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        addSubViews()
    }
    
    public init(state: HomeForecastCellState) {
        super.init(frame: .zero)
        addSubViews()
        configureCellState(state: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
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
    func addSubViews() {
        addSubview(container)
        container.addSubview(mainTempLabel)
        container.addSubview(sensoryTempLabel)
        container.addSubview(dailyTempLabel)
        container.addSubview(weatherImage)
        container.addSubview(commentLabel)
        
        self.setCornerRadius(14)
    }
    
    func layout() {
        container.pin.all()
        
        mainTempLabel.pin
            .top(27).left(20)
            .size(68)
        
        sensoryTempLabel.pin
            .after(of: mainTempLabel)
            .marginLeft(18).top(38)
            .width(42).height(17)
        
        dailyTempLabel.pin
            .below(of: sensoryTempLabel)
            .after(of: mainTempLabel)
            .marginLeft(18).marginTop(5)
            .width(60).height(19)
        
        weatherImage.pin
            .top(27).right(20)
            .width(110).height(74)
        
        commentLabel.pin
            .bottom(20)
            .vCenter()
            .marginHorizontal(20)
            .width(295)
            .height(32)
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

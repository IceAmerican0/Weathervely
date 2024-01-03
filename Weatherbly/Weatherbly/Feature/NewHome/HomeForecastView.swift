//
//  HomeForecastView.swift
//  Weatherbly
//
//  Created by Khai on 1/2/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public struct HomeForecastViewState {
    public let mainTemp: String
    public let minTemp: String
    public let maxTemp: String
    public let weather: String
    public let comment: String
}

public final class HomeForecastView: UIView {
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
    }
    
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        addSubViews()
    }
    
    public init(viewState: HomeForecastViewState) {
        super.init(frame: .zero)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public func configureViewState(viewState: HomeForecastViewState) {
        mainTempLabel.text = "\(viewState.mainTemp)°"
        dailyTempLabel.text = "\(viewState.minTemp)° / \(viewState.maxTemp)°"
        commentLabel.text = viewState.comment
        
        self.backgroundColor = configureBackgroundColor(weather: viewState.weather)
    }
}

private extension HomeForecastView {
    func addSubViews() {
        addSubviews(
            mainTempLabel,
            sensoryTempLabel,
            dailyTempLabel,
            weatherImage,
            commentLabel
        )
    }
    
    func layout() {
        self.pin.all()
        
        mainTempLabel.pin
            .top(27)
            .left(20)
        
        sensoryTempLabel.pin
            .after(of: mainTempLabel)
            .marginLeft(18)
            .top(11)
        
        dailyTempLabel.pin
            .below(of: sensoryTempLabel)
            .marginTop(5)
        
        weatherImage.pin
            .top(27)
            .right(20)
            .width(110)
            .height(74)
        
        commentLabel.pin
            .bottom(20)
            .marginHorizontal(20)
    }
    
    func configureBackgroundColor(weather: String) -> UIColor {
        switch weather {
        case "맑음": UIColor.sky600
        case "흐림": UIColor.sky600
        case "구름많음": UIColor.sky600
        case "비": UIColor.sky600
        case "눈비": UIColor.sky600
        case "눈": UIColor.sky600
        case "바람": UIColor.sky600
        default: UIColor.sky600
        }
    }
}

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
import RxSwift
import RxGesture

public final class HomeForecastCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    private let loadFailedView = UIView().then {
        $0.isHidden = true
    }
    
    private let failImageView = UIImageView().then {
        $0.image = .home_weather_empty
    }
    
    private let failLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .white
    ).make(text: "날씨를 불러올 수 없습니다.")
    
    private let successView = UIView()
    
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
        fontColor: .white,
        alignment: .center
    ).make().then {
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.backgroundColor = .black10
        $0.setCornerRadius(10.5)
        $0.layer.masksToBounds = true
    }
    
    var swipeGesture: SwipeControlEvent {
        self.contentView.rx.swipeGesture([.left, .right])
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public func configureCellState(state: HomeForecastInfo) {
        mainTempLabel.text = "\(state.currentTemp)°"
        mainTempLabel.flex.markDirty()
        dailyTempLabel.text = "\(String(Int(Double(state.minTemp) ?? 0.0)))° / \(String(Int(Double(state.maxTemp) ?? 0.0)))°"
        dailyTempLabel.flex.markDirty()
        commentLabel.text = state.comment
        
        let (gradient, image) = setWeatherUI(weather: state.weather, time: state.time ?? Date().currentTime())
        weatherImage.image = image
        addGradient(colors: gradient)
    }
    
    public func loadFailed() {
        successView.isHidden = true
        loadFailedView.isHidden = false
    }
}

private extension HomeForecastCell {
    func setLayout() {
        setCornerRadius(12)
        clipsToBounds = true
        
        contentView.addSubview(loadFailedView)
        contentView.addSubview(successView)
        loadFailedView.addSubview(failImageView)
        loadFailedView.addSubview(failLabel)
        successView.addSubview(mainTempLabel)
        successView.addSubview(sensoryTempLabel)
        successView.addSubview(dailyTempLabel)
        successView.addSubview(weatherImage)
        successView.addSubview(commentLabel)
    }
    
    func layout() {
        successView.flex.layout()
        loadFailedView.flex.layout()
        
        successView.pin.all()
        loadFailedView.pin.all()
        
        failImageView.pin.hCenter().top(37).size(48)
        failLabel.pin.below(of: failImageView, aligned: .center).marginTop(10).sizeToFit()
        mainTempLabel.pin.left(20).top(27).maxHeight(67).sizeToFit()
        weatherImage.pin.topRight(20).width(110).height(74)
        sensoryTempLabel.pin.after(of: mainTempLabel).marginLeft(20).top(38).sizeToFit()
        dailyTempLabel.pin.below(of: sensoryTempLabel, aligned: .left).marginTop(5).sizeToFit()
        commentLabel.pin.horizontally(20).bottom(20).height(32)
    }
}

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
        $0.backgroundColor = .black10
        $0.setCornerRadius(10.5)
        $0.layer.masksToBounds = true
    }
    
    var swipeGesture: SwipeControlEvent {
        self.contentView.rx.swipeGesture([.left, .right])
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        setLayout()
        return contentView.frame.size
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public func configureCellState(state: HomeForecastInfo) {
        mainTempLabel.text = "\(state.mainTemp)°"
        dailyTempLabel.text = "\(state.minTemp)° / \(state.maxTemp)°"
        commentLabel.text = state.comment
        
        let (gradient, image) = setWeatherUI(weather: state.weather, isDayTime: String(state.time.prefix(2)))
        weatherImage.image = image
        gradient.frame = bounds
        gradient.bounds = bounds.insetBy(
            dx: (-0.5 * bounds.size.width),
            dy: (-0.5 * bounds.size.height)
        )
        gradient.position = contentView.center
        contentView.layer.insertSublayer(gradient, at: 0)
        contentView.flex.markDirty()
        setNeedsLayout()
    }
}

private extension HomeForecastCell {
    func setLayout() {
        contentView.flex.layout()
    }
    
    func layout() {
        setCornerRadius(12)
        clipsToBounds = true
        
        contentView.flex.alignItems(.center).define {
            $0.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).marginTop(27).width(100%).define {
                $0.addItem(mainTempLabel).marginLeft(20).size(68)
                $0.addItem().marginTop(-10).marginLeft(18).grow(1).define { middle in
                    middle.addItem(sensoryTempLabel)
                    middle.addItem(dailyTempLabel).marginTop(5)
                }
                $0.addItem(weatherImage).marginRight(20).width(110).height(74)
            }
            $0.addItem(commentLabel).alignSelf(.stretch).marginHorizontal(20).marginTop(4).height(32)
        }
    }
}

extension UIView {
    public func setWeatherUI(weather: String, isDayTime: String) -> (CAGradientLayer, UIImage) {
        switch weather {
        case "맑음": isDayTime == "오전" ?
            (.gradient10, UIImage.sunny_am) :
            (.gradient20, UIImage.sunny_pm)
        case "흐림": (.gradient30, UIImage.cloudy)
        case "구름많음": isDayTime == "오전" ?
            (.gradient40, UIImage.clouds_am) :
            (.gradient50, UIImage.clouds_pm)
        case "비": (.gradient60, UIImage.rainy)
        case "눈비": (.gradient70, UIImage.snowyRainy)
        case "눈": (.gradient80, UIImage.snowy)
        case "바람": (.gradient90, UIImage.windy)
        default: (.gradient10, UIImage.sunny_am)
        }
    }
}

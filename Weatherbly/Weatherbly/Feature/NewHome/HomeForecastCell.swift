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
    
    private let weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
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
        mainTempLabel.flex.markDirty()
        dailyTempLabel.text = "\(state.minTemp)° / \(state.maxTemp)°"
        dailyTempLabel.flex.markDirty()
        commentLabel.text = state.comment
        
        let (gradient, image) = setWeatherUI(weather: state.weather, time: String(state.time))
        weatherImage.image = image
        addGradient(colors: gradient)
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
            $0.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).alignSelf(.stretch).marginHorizontal(20).marginTop(27).define {
                $0.addItem(mainTempLabel)
                $0.addItem().marginTop(-10).marginLeft(18).grow(1).define { middle in
                    middle.addItem(sensoryTempLabel)
                    middle.addItem(dailyTempLabel).marginTop(5)
                }
                $0.addItem(weatherImage).width(110).height(74)
            }
            $0.addItem(commentLabel).alignSelf(.stretch).marginHorizontal(20).marginTop(4).height(32)
        }
    }
}

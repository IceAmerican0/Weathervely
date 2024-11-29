//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by Khai on 1/30/24.
//

import DesignSystem
import UIUtil
import UIKit
import RxSwift

public protocol TenDaysForecastViewDelegate {
    func backButtonTapped()
}

public final class TenDaysForeCastViewController: RxBaseViewController<TenDaysForecastViewModel> {
    private var navigationView = CSNavigationView(.leftOnly(.navi_back_white)).then {
        $0.backgroundColor = .clear
        $0.setTitle("10일간 예보")
        $0.setTitleColor(color: .white)
    }
    
    private let shimmerView = TendaysForecastShimmerView()
    
    private let contentView = UIView()
    
    private let todayLabel = LabelMaker(
        font: .body_5_B,
        fontColor: .white
    ).make(text: "오늘")
    
    private let divider = UIView().then {
        $0.backgroundColor = .white30
    }
    
    private let dateLabel = LabelMaker(
        font: .body_5_B,
        fontColor: .white
    ).make(text: Date().todayWeekFormat)
    
    private let mainTempLabel = LabelMaker(
        font: .heading_1_UL,
        fontColor: .white
    ).make().then {
        $0.sizeToFit()
    }
    
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
    
    private lazy var forecastTableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear10
        $0.setCornerRadius(12)
        $0.contentInset.top = 12
        $0.separatorColor = .white20
        $0.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        $0.register(withType: TenDaysForecastTableViewCell.self)
    }
    
    var delegate: TenDaysForecastViewDelegate?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getForecastData()
    }
    
    public override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView)
            $0.addItem(shimmerView).grow(1)
            $0.addItem(contentView).grow(1).define {
                $0.addItem().direction(.row).alignItems(.center).marginTop(25).define { date in
                    date.addItem(todayLabel).marginLeft(20)
                    date.addItem(divider).marginLeft(12).width(1).height(10)
                    date.addItem(dateLabel).marginLeft(12)
                }
                $0.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).marginTop(12).define { weather in
                    weather.addItem(mainTempLabel).marginLeft(20).shrink(1)
                    weather.addItem().marginHorizontal(18).grow(1).define { middle in
                        middle.addItem(sensoryTempLabel)
                        middle.addItem(dailyTempLabel).marginTop(7)
                    }
                    weather.addItem(weatherImage).marginRight(20).width(110).height(74)
                }
                $0.addItem(forecastTableView).marginTop(16).marginHorizontal(20).marginBottom(20).grow(1)
            }.display(.none)
        }
    }
    
    public override func viewModelBinding() {
        super.viewModelBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.delegate?.backButtonTapped()
            }).disposed(by: bag)
        
        viewModel.shimmerStatus
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(with: self) { owner, _ in
                owner.shimmerView.removeFromSuperview()
                owner.contentView.flex.display(.flex)
                owner.container.flex.layout()
            }.disposed(by: bag)
        
        viewModel.currentTemp
            .bind(with: self) { owner, data in
                owner.mainTempLabel.text = "\(data)°"
                owner.mainTempLabel.flex.markDirty()
            }.disposed(by: bag)
        
        viewModel.currentWeather
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, data in
                    let (gradient, image) = owner.view.setTenDaysWeatherUI(weather: data, time: Date().currentTime())
                    owner.weatherImage.image = image
                    owner.view.addGradient(colors: gradient)
                    
                    // 화면 전환시 잔상 해결
                    owner.view.clipsToBounds = true
                }
            ).disposed(by: bag)
        
        viewModel.forecastInfo
            .bind(to: forecastTableView.rx.items(
                cellIdentifier: TenDaysForecastTableViewCell.identifier,
                cellType: TenDaysForecastTableViewCell.self
            )) { _, data, cell in
                cell.selectionStyle = .none
                cell.configureCellState(state: data)
            }.disposed(by: bag)
        
        viewModel.forecastInfo
            .bind(with: self) { owner, data in
                owner.dailyTempLabel.text = "\(data[1].minTemp)° / \(data[1].maxTemp)°"
                owner.dailyTempLabel.flex.markDirty()
            }.disposed(by: bag)
    }
}

extension TenDaysForeCastViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.alpha = 0.4
        }
        
        if indexPath.row == 10 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
    }
}

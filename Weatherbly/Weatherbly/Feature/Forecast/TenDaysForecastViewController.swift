//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by Khai on 1/30/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class TenDaysForeCastViewController: RxBaseViewController<TenDaysForecastViewModel> {
    
    private var navigationView = CSNavigationView(.leftButton(.navi_back)).then {
        $0.setTitle("10일간 예보")
    }
    
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
    ).make(text: "")
    
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
    
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.rowHeight = 49
        $0.backgroundColor = .clear
        $0.register(withType: TenDaysForecastTableViewCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.getForecastData()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define {
            $0.addItem(navigationView).width(100%)
            $0.addItem().direction(.row).marginTop(25).define { date in
                date.addItem(todayLabel).marginLeft(20)
                date.addItem(divider).marginLeft(12).width(1).height(10)
                date.addItem(dateLabel).marginLeft(12)
            }
            $0.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).marginTop(12).width(100%).define { weather in
                weather.addItem(mainTempLabel).marginLeft(20).size(68)
                weather.addItem().marginTop(-13).marginLeft(18).grow(1).define { middle in
                    middle.addItem(sensoryTempLabel)
                    middle.addItem(dailyTempLabel).marginTop(7)
                }
                weather.addItem(weatherImage).marginRight(20).width(110).height(74)
            }
            $0.addItem(tableView).grow(1)
        }
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.currentTemp
            .bind(to: mainTempLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.currentWeather
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, data in
                    owner.view.backgroundColor = .red200
                }
            ).disposed(by: bag)
        
        viewModel.forecastInfo
            .bind(to: tableView.rx.items(
                cellIdentifier: TenDaysForecastTableViewCell.identifier,
                cellType: TenDaysForecastTableViewCell.self
            )) { _, data, cell in
                cell.configureCellState(state: data)
            }.disposed(by: bag)
    }
}

extension TenDaysForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

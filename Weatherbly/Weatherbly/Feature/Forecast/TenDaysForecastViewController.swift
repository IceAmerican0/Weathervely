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
import RxSwift

final class TenDaysForeCastViewController: RxBaseViewController<TenDaysForecastViewModel> {
    private var navigationView = CSNavigationView(.leftButton(.navi_back_white)).then {
        $0.backgroundColor = .clear
        $0.setTitle("10일간 예보")
        $0.setTitleColor(color: .white)
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
    ).make(text: Date().todayWeekFormat)
    
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
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .clear10
        $0.setCornerRadius(12)
        $0.contentInset.top = 12
        $0.separatorColor = .white20
        $0.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        $0.register(withType: TenDaysForecastTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getForecastData()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView).width(100%)
            $0.addItem().direction(.row).alignItems(.center).marginTop(25).define { date in
                date.addItem(todayLabel).marginLeft(20)
                date.addItem(divider).marginLeft(12).width(1).height(10)
                date.addItem(dateLabel).marginLeft(12)
            }
            $0.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).marginTop(12).width(100%).define { weather in
                weather.addItem(mainTempLabel).marginLeft(20).size(68)
                weather.addItem().marginTop(-13).marginLeft(18).grow(1).define { middle in
                    middle.addItem(sensoryTempLabel)
                    middle.addItem(dailyTempLabel).marginTop(7).grow(1)
                }
                weather.addItem(weatherImage).marginRight(20).width(110).height(74)
            }
            $0.addItem(tableView).marginTop(16).marginHorizontal(20).marginBottom(20).grow(1)
        }
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        viewModel.currentTemp
            .bind(with: self) { owner, data in
                owner.mainTempLabel.text = "\(data)°"
            }.disposed(by: bag)
        
        viewModel.currentWeather
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, data in
                    let (gradient, image) = owner.view.setWeatherUI(weather: data, time: "오전")
                    owner.weatherImage.image = image
                    owner.view.addGradient(colors: gradient)
                    
                    // 화면 전환시 잔상 해결
                    owner.view.clipsToBounds = true
                }
            ).disposed(by: bag)
        
        viewModel.forecastInfo
            .bind(to: tableView.rx.items(
                cellIdentifier: TenDaysForecastTableViewCell.identifier,
                cellType: TenDaysForecastTableViewCell.self
            )) { _, data, cell in
                cell.configureCellState(state: data)
            }.disposed(by: bag)
        
        viewModel.forecastInfo
            .bind(with: self) { owner, data in
                owner.dailyTempLabel.text = "\(data[1].minTemp)° / \(data[1].maxTemp)°"
            }.disposed(by: bag)
    }
}

extension TenDaysForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 9 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
    }
}

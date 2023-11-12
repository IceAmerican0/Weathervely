//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/04.
//

import UIKit
import FlexLayout
import PinLayout

class TenDaysForeCastViewController: RxBaseViewController<TenDaysForecastViewModel> {
    
    private var mainLabel = CSLabel(.bold, 22, "주간 예보")
    private var divider = UIView()
    private var yesterdayView = UIView()
    private var yesterdayLabel = CSLabel(.regular, 16, "어제")
    private var yesterdayTemperature = CSLabel(.regular, 16, "")
    private var forecastWrapper = UIView()
    private var forecastTableView = UITableView()
    private let indicator = UIActivityIndicatorView(style: .large)
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.58
    private let tableViewWidth = UIScreen.main.bounds.width * 0.92
    private let tableViewHeight = UIScreen.main.bounds.height * 0.71
    
    private lazy var forecast = viewModel.forecastUseCase
    
    override func attribute() {
        super.attribute()
        
        divider.do {
            $0.backgroundColor = CSColor._220_220_220.color
        }
        
        yesterdayView.do {
            $0.layer.borderColor = CSColor._217_217_217_04.cgColor
            $0.layer.borderWidth = 1
            $0.setCornerRadius(5)
        }
        
        yesterdayLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .regular("어제", 16, CSColor._97_97_97)
        }
        
        forecastWrapper.do {
            $0.layer.setShadow(CGSize(width: 0, height: 4), CSColor.none.cgColor, 0.25, 2)
        }
        
        forecastTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = true
            $0.register(TenDaysForecastTableViewCell.self, forCellReuseIdentifier: TenDaysForecastTableViewCell.identifier)
            $0.layer.cornerRadius = 5
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
            $0.layer.masksToBounds = true
            $0.allowsSelection = false
            $0.bounces = false
        }
        
        indicator.do {
            $0.startAnimating()
            $0.isHidden = false
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(mainLabel).marginTop(7).width(mainLabelWidth)

            flex.addItem(yesterdayView).marginTop(15).marginHorizontal(15)
                .direction(.row)
                .alignItems(.center)
                .width(tableViewWidth).height(33)
                .define { flex in
                flex.addItem(yesterdayLabel).marginLeft(20)
                flex.addItem(yesterdayTemperature).position(.absolute).marginVertical(2).right(10)
            }
            
            flex.addItem(forecastWrapper).marginTop(5).marginHorizontal(15).define { flex in
                flex.addItem(forecastTableView).width(tableViewWidth).height(tableViewHeight)
            }
            
            flex.addItem(indicator)
        }
        
        indicator.pin.vCenter().hCenter()
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.yesterdayForecastInfo
            .asDriver(onErrorJustReturn: ["":""])
            .drive(
                with: self,
                onNext: { owner, data in
                    guard let data else { return }
                    let minTemp = Int(Double(data["TMN"]!)!)
                    let maxTemp = Int(Double(data["TMX"]!)!)
                    
                    owner.yesterdayTemperature.attributedText = NSMutableAttributedString()
                        .regular("\(minTemp)℃ / \(maxTemp)℃", 16, CSColor._97_97_97)
            })
            .disposed(by: bag)
        
        forecast.sevenDaysForecastInfo
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    owner.indicator.stopAnimating()
                    owner.indicator.isHidden = true
                    owner.forecastTableView.reloadData()
            })
            .disposed(by: bag)
    }
}

// MARK: UITableViewDelegate
extension TenDaysForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { tableViewHeight * 0.1 }
}

extension TenDaysForeCastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 10 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(withType: TenDaysForecastTableViewCell.self, for: indexPath).then {
            let date = Date()
            let row = indexPath.row - 2
            
            guard let sevenDaysInfo = forecast.sevenDaysForecastInfo.value,
                  let todayInfo = viewModel.todayForecastInfo,
                  let tomorrowInfo = viewModel.tomorrowForecastInfo else { return }
            
            switch indexPath.row {
            case 0:
                let minTemp = Int(Double(todayInfo["TMN"]!)!)
                let maxTemp = Int(Double(todayInfo["TMX"]!)!)
                let (todayAMPos, todayAMImage) = forecast.getAMWeatherInfo(dayInterval: 0)
                let (todayPMPos, todayPMImage) = forecast.getPMWeatherInfo(dayInterval: 0)
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold("오늘", 16, CSColor.none)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(0), 14, CSColor.none)
                $0.amWeatherImageView.setAssetsImage(todayAMImage)
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(todayAMPos)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(todayPMImage)
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(todayPMPos)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
//                $0.isRainPosLabelHidden(viewModel.yesterdayRainAMPosRelay.value!, viewModel.yesterdayRainPMPosRelay.value!)
                
            case 1:
                let minTemp = Int(Double(tomorrowInfo["TMN"]!)!)
                let maxTemp = Int(Double(tomorrowInfo["TMX"]!)!)
                let (tomorrowAMPos, tomorrowAMImage) = forecast.getAMWeatherInfo(dayInterval: 1)
                let (tomorrowPMPos, tomorrowPMImage) = forecast.getPMWeatherInfo(dayInterval: 1)
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold("내일", 16, CSColor.none)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(1), 14, CSColor.none)
                $0.amWeatherImageView.setAssetsImage(tomorrowAMImage)
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(tomorrowAMPos)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(tomorrowPMImage)
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(tomorrowPMPos)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
//                $0.isRainPosLabelHidden(viewModel.yesterdayRainAMPosRelay.value!, viewModel.yesterdayRainPMPosRelay.value!)
                
            case 2...6:
                var minTemp = sevenDaysInfo.temperature[row].taMin
                var maxTemp = sevenDaysInfo.temperature[row].taMax
                let amRainPos = sevenDaysInfo.weather[row].rnStAm
                let pmRainPos = sevenDaysInfo.weather[row].rnStPm
                
                if sevenDaysInfo.temperature[row].taMinLow > 2 {
                    minTemp = minTemp + (minTemp - sevenDaysInfo.temperature[row].taMinLow) / 2
                }
                
                if sevenDaysInfo.temperature[row].taMaxHigh > 2 {
                     maxTemp = maxTemp + (maxTemp - sevenDaysInfo.temperature[row].taMaxHigh) / 2
                 }
                
                let dayofTheWeek = date.dayOfTheWeek(indexPath.row - 1)
                let dateColor = (dayofTheWeek == "토")
                ? CSColor._40_106_167
                : (dayofTheWeek == "일") ? CSColor._178_36_36 : CSColor.none
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold(dayofTheWeek, 16, dateColor)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(indexPath.row - 1), 14, dateColor)
                $0.amWeatherImageView.setAssetsImage(forecast.bindSevenDayAMWeatherImage(index: row))
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(amRainPos ?? 0)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(forecast.bindSevenDayPMWeatherImage(index: row))
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(pmRainPos ?? 0)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
//                $0.isRainPosLabelHidden(amRainPos ?? 0, pmRainPos ?? 0)
                
            case 7...9:
                var minTemp = sevenDaysInfo.temperature[row].taMin
                var maxTemp = sevenDaysInfo.temperature[row].taMax
                let rainPos = sevenDaysInfo.weather[row].rnSt
                
                if sevenDaysInfo.temperature[row].taMinLow > 2 {
                    minTemp = minTemp + (minTemp - sevenDaysInfo.temperature[row].taMinLow) / 2
                }
                
                if sevenDaysInfo.temperature[row].taMaxHigh > 2 {
                     maxTemp = maxTemp + (maxTemp - sevenDaysInfo.temperature[row].taMaxHigh) / 2
                 }
                
                let dayofTheWeek = date.dayOfTheWeek(indexPath.row - 1)
                let dateColor = (dayofTheWeek == "토")
                ? CSColor._40_106_167
                : (dayofTheWeek == "일") ? CSColor._178_36_36 : CSColor.none
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold(dayofTheWeek, 16, dateColor)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(indexPath.row - 1), 14, dateColor)
                $0.amWeatherImageView.setAssetsImage(forecast.bindSevenDayAMWeatherImage(index: row))
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(rainPos ?? 0)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(forecast.bindSevenDayPMWeatherImage(index: row))
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(rainPos ?? 0)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
//                $0.isRainPosLabelHidden(rainPos ?? 0, rainPos ?? 0)
                
            default:
                break
            }
            
        }
    
    }
    
}

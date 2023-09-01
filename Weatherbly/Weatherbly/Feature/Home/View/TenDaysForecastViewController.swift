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
    
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabel = CSLabel(.bold, 22, "주간 예보")
    private var homeButton = UIButton()
    
    private var divider = UIView()
    private var yesterdayView = UIView()
    private var yesterdayLabel = CSLabel(.regular, 16, "어제")
    private var yesterdayTemperature = CSLabel(.regular, 16, "")
    private var tableViewWrapper = UIView()
    private var forecastTableView = UITableView()
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.58
    private let tableViewWidth = UIScreen.main.bounds.width * 0.92
    private let tableViewHeight = UIScreen.main.bounds.height * 0.71
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.dataSource = self
        forecastTableView.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func attribute() {
        super.attribute()
        
        settingButton.do {
            $0.setImage(AssetsImage.setting.image, for: .normal)
        }
        
        homeButton.do {
            $0.setImage(AssetsImage.daily.image, for: .normal)
        }
        
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
        
        tableViewWrapper.do {
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
            $0.layer.setShadow(CGSize(width: 0, height: 4), CSColor.none.cgColor, 0.25, 2)
            $0.layer.masksToBounds = false
            $0.allowsSelection = false
            $0.bounces = false
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingButton).size(44)
                flex.addItem(mainLabel).width(mainLabelWidth)
                flex.addItem(homeButton).size(44)
            }
            
            flex.addItem(divider).marginTop(15).width(UIScreen.main.bounds.width).height(1.3)
            
            flex.addItem(yesterdayView).marginTop(UIScreen.main.bounds.height * 0.04).marginHorizontal(15)
                .direction(.row)
                .alignItems(.center)
                .width(tableViewWidth).height(33)
                .define { flex in
                flex.addItem(yesterdayLabel)
                flex.addItem(yesterdayTemperature)
            }
            
            flex.addItem(forecastTableView).marginTop(5).marginHorizontal(15).width(tableViewWidth).height(tableViewHeight)
        }
        
        yesterdayLabel.pin.left(to: yesterdayView.edge.left).marginLeft(18)
        yesterdayTemperature.pin.right(to: yesterdayView.edge.right).marginRight(17)
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        settingButton.rx.tap
            .map { SettingViewController(SettingViewModel()) }
            .bind(to: viewModel.navigationPushViewControllerRelay)
            .disposed(by: bag)
        
        homeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel
            .yesterdayInfoRelay
            .subscribe(onNext: { [weak self] data in
                guard let info = data else { return }
                let minTemp = Int(Double(info["TMN"]!)!)
                let maxTemp = Int(Double(info["TMX"]!)!)
                
                self?.yesterdayTemperature.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃ / \(maxTemp)℃", 16, CSColor._97_97_97)
            })
            .disposed(by: bag)
        
        viewModel
            .sevenDayForecastInfoRelay
            .subscribe(onNext: { [weak self] info in
                guard let _ = info else { return }
                self?.forecastTableView.reloadData()
                
            })
            .disposed(by: bag)
        
        viewModel.getInfo()
    }
}

// MARK: UITableViewDelegate
extension TenDaysForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
}

extension TenDaysForeCastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 10 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(withType: TenDaysForecastTableViewCell.self, for: indexPath).then {
            
            guard let sevenDaysInfo = viewModel.sevenDayForecastInfoRelay.value?.data.list,
                  let todayInfo = viewModel.todayInfoRelay.value,
                  let tomorrowInfo = viewModel.tomorrowInfoRelay.value,
                  let villageForecastInfo = viewModel.villageForecastEntityRelay.value
            else { return }
            
            let date = Date()
            let row = indexPath.row - 2
            
            switch indexPath.row {
            case 0:
                let minTemp = Int(Double(todayInfo["TMN"]!)!)
                let maxTemp = Int(Double(todayInfo["TMX"]!)!)
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold("오늘", 16, CSColor.none)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(0), 14, CSColor.none)
                $0.amWeatherImageView.setAssetsImage(viewModel.getAMWeatherImage(villageForecastInfo, 0)!)
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(viewModel.yesterdayRainAMPosRelay.value!)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.getPMWeatherImage(villageForecastInfo, 0)!)
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(viewModel.yesterdayRainAMPosRelay.value!)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
                $0.isRainPosLabelHidden(viewModel.yesterdayRainAMPosRelay.value!, viewModel.yesterdayRainPMPosRelay.value!)
                
            case 1:
                let minTemp = Int(Double(tomorrowInfo["TMN"]!)!)
                let maxTemp = Int(Double(tomorrowInfo["TMX"]!)!)
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold("내일", 16, CSColor.none)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(1), 14, CSColor.none)
                $0.amWeatherImageView.setAssetsImage(viewModel.getAMWeatherImage(villageForecastInfo, 1)!)
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(viewModel.yesterdayRainAMPosRelay.value!)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.getPMWeatherImage(villageForecastInfo, 1)!)
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(viewModel.yesterdayRainAMPosRelay.value!)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
                $0.isRainPosLabelHidden(viewModel.yesterdayRainAMPosRelay.value!, viewModel.yesterdayRainPMPosRelay.value!)
                
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
                $0.amWeatherImageView.setAssetsImage(viewModel.bindSevenDayAMWeatherImage(row))
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(amRainPos ?? 0)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.bindSevenDayPMWeatherImage(row))
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(pmRainPos ?? 0)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
                $0.isRainPosLabelHidden(amRainPos ?? 0, pmRainPos ?? 0)
                
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
                
                var dayofTheWeek = date.dayOfTheWeek(indexPath.row - 1)
                var dateColor = (dayofTheWeek == "토")
                ? CSColor._40_106_167
                : (dayofTheWeek == "일") ? CSColor._178_36_36 : CSColor.none
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold(dayofTheWeek, 16, dateColor)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(indexPath.row - 1), 14, dateColor)
                $0.amWeatherImageView.setAssetsImage(viewModel.bindSevenDayAMWeatherImage(row))
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(rainPos ?? 0)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.bindSevenDayPMWeatherImage(row))
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(rainPos ?? 0)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
                $0.isRainPosLabelHidden(rainPos ?? 0, rainPos ?? 0)
                
            default:
                break
            }
            
        }
    
    }
    
}

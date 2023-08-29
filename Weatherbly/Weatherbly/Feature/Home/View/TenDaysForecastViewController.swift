//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/04.
//

import UIKit

class TenDaysForeCastViewController: RxBaseViewController<TenDaysForecastViewModel> {
    
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabel = CSLabel(.bold, 22, "주간 예보")
    private var homeButton = UIButton()
    
    private var divider = UIView()
    private var tableViewWrapper = UIView()
    private var forecastTableView = UITableView()
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.58
    private let tableViewWidth = UIScreen.main.bounds.width * 0.92
    private let tableViewHeight = UIScreen.main.bounds.height * 0.7
    
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
            $0.layer.masksToBounds = true
            $0.clipsToBounds = true
            $0.allowsSelection = false
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
            flex.addItem(tableViewWrapper).marginTop(40).marginHorizontal(15).width(tableViewWidth).height(tableViewHeight)
                .define { flex in
                    flex.addItem(forecastTableView).width(tableViewWidth).height(tableViewHeight)
                }
        }
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
            .sevenDayForecastInfoRelay
            .subscribe(onNext: { [weak self] info in
                guard let _ = info else { return }
                self?.forecastTableView.reloadData()
                
            })
            .disposed(by: bag)
        
        viewModel.getInfo()
    }
    
    // MARK: - Method
    
    func set3To10Info(_ info: SevenDayForecastInfoEntity) {
        
    }

}

// MARK: UITableViewDelegate
extension TenDaysForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
}

extension TenDaysForeCastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 11 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(withType: TenDaysForecastTableViewCell.self, for: indexPath).then {
            
            guard let sevenDaysInfo = viewModel.sevenDayForecastInfoRelay.value?.data.list,
                  let todayInfo = viewModel.todayInfoRelay.value,
                  let yesterdayInfo = viewModel.yesterdayInfoRelay.value,
                  let tomorrowInfo = viewModel.tomorrowInfoRelay.value,
                  let villageForecastInfo = viewModel.villageForecastEntityRelay.value
            else { return }
            
            let date = Date()
            
            switch indexPath.row {
            case 0:
                let minTemp = Int(Double(yesterdayInfo["TMN"]!)!)
                let maxTemp = Int(Double(yesterdayInfo["TMX"]!)!)
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold("어제", 16, CSColor.none)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(-1), 14, CSColor.none)
                $0.amWeatherImageView.setAssetsImage(viewModel.getAMWeatherImage(villageForecastInfo, -1)!)
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(viewModel.yesterdayRainAMPosRelay.value!)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.getPMWeatherImage(villageForecastInfo, -1)!)
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(viewModel.yesterdayRainAMPosRelay.value!)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
                $0.isRainPosLabelHidden(viewModel.yesterdayRainAMPosRelay.value!, viewModel.yesterdayRainPMPosRelay.value!)
                
            case 1:
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
                
            case 2:
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
                
            case 3...7:
                var minTemp = sevenDaysInfo.temperature[indexPath.row - 3].taMin
                var maxTemp = sevenDaysInfo.temperature[indexPath.row - 3].taMax
                var amRainPos = sevenDaysInfo.weather[indexPath.row - 3].rnStAm
                var pmRainPos = sevenDaysInfo.weather[indexPath.row - 3].rnStPm
                
                if sevenDaysInfo.temperature[indexPath.row - 3].taMinLow > 2 {
                    minTemp = minTemp + (minTemp - sevenDaysInfo.temperature[indexPath.row - 3].taMinLow) / 2
                }
                
                if sevenDaysInfo.temperature[indexPath.row - 3].taMaxHigh > 2 {
                     maxTemp = maxTemp + (maxTemp - sevenDaysInfo.temperature[indexPath.row - 3].taMaxHigh) / 2
                 }
                
                var dayofTheWeek = date.dayOfTheWeek(indexPath.row - 1)
                var dateColor = (dayofTheWeek == "토")
                ? CSColor._40_106_167
                : (dayofTheWeek == "일") ? CSColor._178_36_36 : CSColor.none
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold(dayofTheWeek, 16, dateColor)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(indexPath.row - 1), 14, dateColor)
                $0.amWeatherImageView.setAssetsImage(viewModel.bindSevenDayAMWeatherImage(indexPath.row - 3))
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(amRainPos ?? 0)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.bindSevenDayPMWeatherImage(indexPath.row - 3))
                $0.rightRainPosLabel.attributedText = NSMutableAttributedString().medium("\(pmRainPos ?? 0)%", 12, CSColor.none)
                $0.temperatureLabel.attributedText = NSMutableAttributedString()
                    .regular("\(minTemp)℃", 16, CSColor._40_106_167)
                    .regular(" / ", 16, CSColor.none)
                    .regular("\(maxTemp)℃", 16, CSColor._178_36_36)
                $0.isRainPosLabelHidden(amRainPos ?? 0, pmRainPos ?? 0)
                
            case 8...10:
                var minTemp = sevenDaysInfo.temperature[indexPath.row - 3].taMin
                var maxTemp = sevenDaysInfo.temperature[indexPath.row - 3].taMax
                var rainPos = sevenDaysInfo.weather[indexPath.row - 3].rnSt
                
                if sevenDaysInfo.temperature[indexPath.row - 3].taMinLow > 2 {
                    minTemp = minTemp + (minTemp - sevenDaysInfo.temperature[indexPath.row - 3].taMinLow) / 2
                }
                
                if sevenDaysInfo.temperature[indexPath.row - 3].taMaxHigh > 2 {
                     maxTemp = maxTemp + (maxTemp - sevenDaysInfo.temperature[indexPath.row - 3].taMaxHigh) / 2
                 }
                
                var dayofTheWeek = date.dayOfTheWeek(indexPath.row - 1)
                var dateColor = (dayofTheWeek == "토")
                ? CSColor._40_106_167
                : (dayofTheWeek == "일") ? CSColor._178_36_36 : CSColor.none
                
                $0.dayOfWeekLabel.attributedText = NSMutableAttributedString().bold(dayofTheWeek, 16, dateColor)
                $0.dateLabel.attributedText = NSMutableAttributedString().regular(date.tenDaysFormat(indexPath.row - 1), 14, dateColor)
                $0.amWeatherImageView.setAssetsImage(viewModel.bindSevenDayAMWeatherImage(indexPath.row - 3))
                $0.leftRainPosLabel.attributedText = NSMutableAttributedString().medium("\(rainPos ?? 0)%", 12, CSColor.none)
                $0.pmWeatherImageView.setAssetsImage(viewModel.bindSevenDayPMWeatherImage(indexPath.row - 3))
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

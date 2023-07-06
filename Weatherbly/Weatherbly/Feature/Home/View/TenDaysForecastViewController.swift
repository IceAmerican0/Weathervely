//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/04.
//

import UIKit

class TenDaysForeCastViewController: BaseViewController {
    
    private var topLayoutWrapper = UIView()
    private var settingImageView = UIButton()
    private var mainLabel = CSLabel(.bold, 22, "주간 예보")
    private var homeImageView = UIButton()
    
    private var divider = UIView()
    private var forecastTableView = UITableView()
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.58
    private let tableViewWidth = UIScreen.main.bounds.width * 0.92
    private let tableViewHeight = UIScreen.main.bounds.height * 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func attribute() {
        super.attribute()
        
        settingImageView.do {
            $0.setImage(AssetsImage.setting.image, for: .normal)
            $0.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        }
        
        homeImageView.do {
            $0.setImage(AssetsImage.daily.image, for: .normal)
            $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }
        
        divider.do {
            $0.backgroundColor = CSColor._220_220_220.color
        }
        
        forecastTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = false
            $0.backgroundColor = CSColor._253_253_253.color
            $0.layer.cornerRadius = 5
            $0.register(TenDaysForecastTableViewCell.self, forCellReuseIdentifier: TenDaysForecastTableViewCell.identifier)
//            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingImageView).size(44)
                flex.addItem(mainLabel).width(mainLabelWidth)
                flex.addItem(homeImageView).size(44)
            }
            
            flex.addItem(divider).marginTop(15).width(UIScreen.main.bounds.width).height(1.3)
            flex.addItem(forecastTableView).marginTop(40).marginHorizontal(15).width(tableViewWidth).height(tableViewHeight)
        }
    }
    
    @objc private func goToSetting() {
        self.navigationController?.pushViewController(SensoryTempViewController(), animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
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
            $0.amWeatherImageView.setAssetsImage(.cloudySunTen)
            $0.pmWeatherImageView.setAssetsImage(.thunderTen)
            $0.temperatureLabel.attributedText = NSMutableAttributedString()
                .regular("20℃", 16, CSColor._40_106_167)
                .regular(" / ", 16, CSColor.none)
                .regular("30℃", 16, CSColor._178_36_36)
        }
    }
    
}

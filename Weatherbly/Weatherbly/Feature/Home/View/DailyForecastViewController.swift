//
//  DailyForecastViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/07.
//

import UIKit

class DailyForecastViewController: RxBaseViewController<EmptyViewModel> {
    
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabel = CSLabel(.bold, 22, "일별 상세 날씨")
    private var homeButton = UIButton()
    
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
        
        settingButton.do {
            $0.setImage(AssetsImage.setting.image, for: .normal)
            $0.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        }
        
        homeButton.do {
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
            $0.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
            //            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingButton).size(44)
                flex.addItem(mainLabel).width(mainLabelWidth).height(29)
                flex.addItem(homeButton).size(44)
            }
            
            flex.addItem(divider).marginTop(15).width(UIScreen.main.bounds.width).height(1.3)
            flex.addItem(forecastTableView).marginTop(40).marginHorizontal(15).width(tableViewWidth).height(tableViewHeight)
        }
    }
    
    @objc private func goToSetting() {
        self.navigationController?.pushViewController(SensoryTempViewController(EmptyViewModel()), animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableViewDelegate
extension DailyForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 25 }
    
}

extension DailyForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemName = ["기온","미세먼지","비 올 확률", "습도"]
        let imageName = [AssetsImage.thermometer, AssetsImage.dust, AssetsImage.rain, AssetsImage.humidity]
        let shadowColor = [CSColor._255_163_163.cgColor, CSColor._214_214_214.cgColor, CSColor._126_212_255.cgColor, CSColor._210_175_255.cgColor]
        
        return tableView.dequeueCell(withType: DailyForecastTableViewCell.self, for: indexPath).then {
            $0.layer.shadowColor = shadowColor[indexPath.row]
            $0.keyLabel.text = itemName[indexPath.row]
            $0.valueLabel.text = ""
            $0.logoImageView.setAssetsImage(imageName[indexPath.row])
        }
    }
}

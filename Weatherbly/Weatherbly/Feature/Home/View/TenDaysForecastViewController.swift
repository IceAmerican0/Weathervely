//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/04.
//

import UIKit

class TenDaysForeCastViewController: RxBaseViewController<EmptyViewModel> {
    
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabel = CSLabel(.bold, 22, "주간 예보")
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
        }
        
        homeButton.do {
            $0.setImage(AssetsImage.daily.image, for: .normal)
        }
        
        divider.do {
            $0.backgroundColor = CSColor._220_220_220.color
        }
        
        forecastTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = false
            $0.backgroundColor = CSColor._253_253_253.color
            $0.register(TenDaysForecastTableViewCell.self, forCellReuseIdentifier: TenDaysForecastTableViewCell.identifier)
            $0.layer.cornerRadius = 5
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.borderWidth = 1
            $0.layer.setShadow(CGSize(width: 0, height: 4), CSColor.none.cgColor, 0.25, 2)
            $0.layer.masksToBounds = false
            $0.clipsToBounds = false
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
            flex.addItem(forecastTableView).marginTop(40).marginHorizontal(15).width(tableViewWidth).height(tableViewHeight)
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
}

// MARK: UITableViewDelegate
extension TenDaysForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
}

extension TenDaysForeCastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 11 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(withType: TenDaysForecastTableViewCell.self, for: indexPath).then {
            $0.amWeatherImageView.setAssetsImage(.cloudyImage)
            $0.pmWeatherImageView.setAssetsImage(.rainnyImage)
            $0.temperatureLabel.attributedText = NSMutableAttributedString()
                .regular("20℃", 16, CSColor._40_106_167)
                .regular(" / ", 16, CSColor.none)
                .regular("30℃", 16, CSColor._178_36_36)
        }
    }
    
}

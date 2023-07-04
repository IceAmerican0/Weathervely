//
//  TenDaysForecastViewController.swift
//  Weatherbly
//
//  Created by 60156056 on 2023/07/04.
//

import UIKit

class TenDaysForeCastViewController: BaseViewController {
    
    private var topLayoutWrapper = UIView()
    private var settingImageView = UIImageView()
    private var mainLabel = CSLabel(.bold, 22, "주간 예보")
    private var homeImageView = UIImageView()
    
    private var divider = UIView()
    private var forecastTableView = UITableView()
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.58
    private let tableViewHeight = UIScreen.main.bounds.height * 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func attribute() {
        super.attribute()
        
        settingImageView.do {
            $0.image = UIImage(systemName: "gear")?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .gray
        }
        
        homeImageView.do {
            $0.image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .gray
        }
        
        divider.do {
            $0.backgroundColor = CSColor._220_220_220.color
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
            flex.addItem(forecastTableView).marginTop(40).marginHorizontal(15).height(tableViewHeight)
        }
    }
}

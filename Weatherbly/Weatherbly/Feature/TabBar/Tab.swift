//
//  Tab.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit

enum Tab: String, CaseIterable {
    case home = "home.fill"
    case schedule
    case trend = "defaultImage"
    case setting
    
    var title: String {
        switch self {
        case .home: "홈"
        case .schedule: "예보"
        case .trend: "추천"
        case .setting: "설정"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home: HomeViewController(HomeViewModel())
        case .schedule: HomeViewController(HomeViewModel())//TenDaysForeCastViewController(TenDaysForecastViewModel())
        case .trend: TrendViewController(TrendViewModel())
        case .setting: SettingViewController(SettingViewModel())
        }
    }
}

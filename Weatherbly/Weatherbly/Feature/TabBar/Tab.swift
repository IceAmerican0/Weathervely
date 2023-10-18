//
//  Tab.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit

enum Tab: CaseIterable {
    case home
    case schedule
    case trending
    case setting
    
    var title: String {
        switch self {
        case .home: "홈"
        case .schedule: "예보"
        case .trending: "추천"
        case .setting: "설정"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home: UIImage(systemName: "house.fill")!
        case .schedule: AssetsImage.schedule.image!
        case .trending: AssetsImage.defaultImage.image!
        case .setting: AssetsImage.setting.image!
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home: HomeViewController(HomeViewModel())
        case .schedule: HomeViewController(HomeViewModel())//TenDaysForeCastViewController(TenDaysForecastViewModel())
        case .trending: TrendingViewController(TrendingViewModel())
        case .setting: SettingViewController(SettingViewModel())
        }
    }
}

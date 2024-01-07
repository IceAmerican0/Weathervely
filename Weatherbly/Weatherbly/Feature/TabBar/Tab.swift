//
//  Tab.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit

enum Tab: CaseIterable {
    case home
    case style
    case setting
    
    var title: String {
        switch self {
        case .home: "홈"
        case .style: "스타일"
        case .setting: "마이페이지"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home: UIImage.tab_home_nor
        case .style: UIImage.tab_style_nor
        case .setting: UIImage.tab_mypage_nor
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home: UIImage.tab_home_sel
        case .style: UIImage.tab_style_sel
        case .setting: UIImage.tab_mypage_sel
        }
    }
    
    var viewController: UIViewController {
        // TODO: Delete Mock Data
        let tempState = HomeForecastCellState(
            isDayTime: true,
            mainTemp: "18",
            minTemp: "10",
            maxTemp: "22",
            weather: "비",
            comment: "흐리고 비가 내려요. 우산 깜빡하진 않으셨죠?"
        )
        
        return switch self {
        case .home: NewHomeViewController(NewHomeViewModel(
            closetDataSource: ClosetDataSource(),
            homeForecastCellState: [tempState]
        ))
        case .style: TrendingViewController(TrendingViewModel())
        case .setting: SettingViewController(SettingViewModel())
        }
    }
}

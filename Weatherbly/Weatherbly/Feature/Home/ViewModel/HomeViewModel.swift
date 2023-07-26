//
//  HomeViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import Foundation
import RxSwift

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    func toSettingView()
    func toDailyForecastView()
    func toTenDaysForecastView()
    func didTapClosetCell()
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    public func toSettingView() {
        let vc = SettingViewController(SettingViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toDailyForecastView() {
        let vc = DailyForecastViewController(EmptyViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toTenDaysForecastView() {
        let vc = TenDaysForeCastViewController(EmptyViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    public func didTapClosetCell() {
        
    }
    
    
}

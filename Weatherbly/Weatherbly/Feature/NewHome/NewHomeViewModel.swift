//
//  NewHomeViewModel.swift
//  Weatherbly
//
//  Created by Khai on 12/31/23.
//

import UIKit
import RxSwift
import RxCocoa

public protocol NewHomeViewModelLogic: ViewModelBusinessLogic {
    func buttonTapAction(action: ButtonTapAction)
    func configureTime()
    func filterCloset()
    func toEditRegionView()
    func toTendaysForecastView()
    
    var homeForecastViewState: [HomeForecastViewState] { get }
}

public final class NewHomeViewModel: RxBaseViewModel, NewHomeViewModelLogic {
    public var homeForecastViewState: [HomeForecastViewState]
    
    var selectedForecastViewState = PublishRelay<HomeForecastViewState>()
    
    public init(homeForecastViewState: [HomeForecastViewState]) {
        self.homeForecastViewState = homeForecastViewState
        
        guard let viewState = homeForecastViewState.first else { return }
        self.selectedForecastViewState.accept(viewState)
    }
    
    public func buttonTapAction(action: ButtonTapAction) {
        switch action {
        case .didTapPrev: configureTime()
        case .didTapNext: configureTime()
        case .didTapStyle: filterCloset()
        case .didTapItem: filterCloset()
        }
    }
    
    /// 시간대 이동 전 시간 판별
    public func configureTime() {
        
    }
    
    /// 필터링
    public func filterCloset() {
        
    }
    
    public func toTendaysForecastView() {
        let forecast = ForecastUseCase(forecastDataSource: ForecastDataSource())
        let vc = TenDaysForeCastViewController(TenDaysForecastViewModel(forecastUseCase: forecast))
        navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel(.edit))
        navigationPushViewControllerRelay.accept(vc)
    }
}

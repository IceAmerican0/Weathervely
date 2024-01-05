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
    
    var homeForecastCellState: [HomeForecastCellState] { get }
}

public final class NewHomeViewModel: RxBaseViewModel, NewHomeViewModelLogic {
    public var homeForecastCellState: [HomeForecastCellState]
    
    var selectedForecastViewState = PublishRelay<HomeForecastCellState>()
    
    public init(homeForecastCellState: [HomeForecastCellState]) {
        self.homeForecastCellState = homeForecastCellState
        
        guard let cellState = homeForecastCellState.first else { return }
        self.selectedForecastViewState.accept(cellState)
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

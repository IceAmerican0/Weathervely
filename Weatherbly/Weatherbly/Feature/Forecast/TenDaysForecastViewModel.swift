//
//  TenDaysForecastViewModel.swift
//  Weatherbly
//
//  Created by Khai on 1/30/24.
//

import UIKit
import RxSwift
import RxCocoa

public protocol TenDaysForecastViewModelLogic: ViewModelBusinessLogic {
    func getForecastData()
    
    var shimmerStatus: PublishRelay<Bool> { get }
    var currentTemp: PublishRelay<String> { get }
    var currentWeather: BehaviorRelay<String> { get }
    var forecastInfo: PublishRelay<[TenDayForecastInfo]> { get }
}

public final class TenDaysForecastViewModel: RxBaseViewModel, TenDaysForecastViewModelLogic {
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 현재온도
    public var currentTemp = PublishRelay<String>()
    /// 현재날씨
    public var currentWeather = BehaviorRelay<String>(value: "")
    /// 날씨정보
    public var forecastInfo = PublishRelay<[TenDayForecastInfo]>()
    
    public func getForecastData() {
        let dataSource: ForecastDataSourceProtocol = ForecastDataSource()
        dataSource.getTenDayForeCast()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.shimmerStatus.accept(true)
//                    let data = response.data
//                    owner.currentTemp.accept("\(data.currentTemp)")
//                    owner.currentWeather.accept(data.currentWeather)
//                    owner.forecastInfo.accept(data.forecast)
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.alertState.accept(
                        .init(title: error.localizedDescription, alertType: .popup)
                    )
                }
            ).disposed(by: bag)
    }
}

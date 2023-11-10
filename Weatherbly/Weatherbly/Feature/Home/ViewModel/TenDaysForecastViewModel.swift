//
//  TenDaysForecastViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol TenDaysForecastViewModelLogic: ViewModelBusinessLogic {
    func getInfo()
}

public final class TenDaysForecastViewModel: RxBaseViewModel, ViewModelBusinessLogic {
    
    public let forecastUseCase: ForecastUseCaseProtocol
    
    /// 어제 예보
    public var yesterdayForecastInfo = BehaviorRelay<[String: String]>(value: [:])
    /// 오늘 예보
    public var todayForecastInfo: [String: String]?
    /// 내일 예보
    public var tomorrowForecastInfo: [String: String]?
    
    init(forecastDataSource: ForecastUseCaseProtocol) {
        self.forecastUseCase = forecastDataSource
        super.init()
        getInfo()
    }
    
    public func getInfo() {
        let date = Date()
        
        forecastUseCase.getSevenDaysForecastInfo()
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.yesterdayForecastInfo.accept(owner.forecastUseCase.bindYesterdayWeather(
                        selectedHour: date.yesterdayThousandFormat
                    ))
                    owner.todayForecastInfo = owner.forecastUseCase.bindTodayWeather(
                        selectedHour: date.todayThousandFormat
                    )
                    owner.tomorrowForecastInfo = owner.forecastUseCase.bindTomorrowWeather(
                        selectedHour: date.tomorrowThousandFormat
                    )
                },
                onError: { owner, error in
                    owner.alertMessageRelay.accept(.init(title: error.localizedDescription,
                                                         alertType: .Error,
                                                         closeAction: {
                        owner.navigationPopViewControllerRelay.accept(Void())
                    }))
            })
            .disposed(by: bag)
    }
}

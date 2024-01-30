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
    
    var currentTemp: PublishRelay<String> { get }
    var currentWeather: BehaviorRelay<String> { get }
    var forecastInfo: PublishRelay<[TenDayForecastInfo]> { get }
}

public final class TenDaysForecastViewModel: RxBaseViewModel, TenDaysForecastViewModelLogic {
    public var currentTemp = PublishRelay<String>()
    public var currentWeather = BehaviorRelay<String>(value: "")
    public var forecastInfo = PublishRelay<[TenDayForecastInfo]>()
    
    public func getForecastData() {
        // TODO: Delete Dummy
        let dummy: [TenDayForecastInfo] = [
            .init(
                date: "어제",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "맑음",
                weatherPM: "비"
            ),
            .init(
                date: "오늘",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "안개",
                weatherPM: "흐림"
            ),
            .init(
                date: "토요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "구름많음",
                weatherPM: "바람"
            ),
            .init(
                date: "일요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "눈비",
                weatherPM: "맑음"
            ),
            .init(
                date: "월요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "구름많음",
                weatherPM: "비"
            ),
            .init(
                date: "화요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "눈",
                weatherPM: "바람"
            ),
            .init(
                date: "수요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "맑음",
                weatherPM: "바람"
            ),
            .init(
                date: "목요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "구름많음",
                weatherPM: "흐림"
            ),
            .init(
                date: "금요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "안개",
                weatherPM: "바람"
            ),
            .init(
                date: "토요일",
                minTemp: 18,
                maxTemp: 25,
                weatherAM: "구름많음",
                weatherPM: "흐림"
            ),
        ]
        currentTemp.accept("18")
        currentWeather.accept("맑음")
        forecastInfo.accept(dummy)
    }
}

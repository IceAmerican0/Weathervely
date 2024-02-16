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
    /// 현재온도
    public var currentTemp = PublishRelay<String>()
    /// 현재날씨
    public var currentWeather = BehaviorRelay<String>(value: "")
    /// 날씨정보
    public var forecastInfo = PublishRelay<[TenDayForecastInfo]>()
    
    public func getForecastData() {
        // TODO: Delete Dummy
        let dummy: [TenDayForecastInfo] = [
            .init(
                date: "어제",
                minTemp: 15,
                maxTemp: 19,
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
                minTemp: 21,
                maxTemp: 23,
                weatherAM: "구름많음",
                weatherPM: "바람"
            ),
            .init(
                date: "일요일",
                minTemp: 19,
                maxTemp: 24,
                weatherAM: "눈비",
                weatherPM: "맑음"
            ),
            .init(
                date: "월요일",
                minTemp: 16,
                maxTemp: 20,
                weatherAM: "구름많음",
                weatherPM: "비"
            ),
            .init(
                date: "화요일",
                minTemp: 19,
                maxTemp: 21,
                weatherAM: "눈",
                weatherPM: "바람"
            ),
            .init(
                date: "수요일",
                minTemp: 20,
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
                minTemp: 15,
                maxTemp: 24,
                weatherAM: "안개",
                weatherPM: "바람"
            ),
            .init(
                date: "토요일",
                minTemp: 20,
                maxTemp: 31,
                weatherAM: "구름많음",
                weatherPM: "흐림"
            ),
        ]
        currentTemp.accept("18")
        currentWeather.accept("맑음")
        forecastInfo.accept(dummy)
    }
}

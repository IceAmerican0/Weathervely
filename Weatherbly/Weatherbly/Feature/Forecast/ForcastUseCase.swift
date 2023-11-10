//
//  ForcastUseCase.swift
//  Weatherbly
//
//  Created by Khai on 11/2/23.
//

import Foundation
import RxCocoa
import RxSwift

public protocol ForecastUseCaseProtocol: AnyObject {
    func getThreeDaysForecastInfo() -> Observable<VillageForecastInfoEntity>
    func getSevenDaysForecastInfo() -> Observable<SevenDayForecastInfoEntity>
    func bindYesterdayWeather(selectedHour: String) -> [String: String]
    func bindTodayWeather(selectedHour: String) -> [String: String]
    func bindTomorrowWeather(selectedHour: String) -> [String: String]
    func bindWeatherByDate(dayInterval: Int, selectedHour: String) -> [String: String]
    func getExtremeTemp(
        categoryWithValue: [String: String],
        orderedByTimeCategories: [Dictionary<String, [String : String]>.Element],
        selectedHour: String
    ) -> [String: String]
    func getAMWeatherInfo(dayInterval: Int) -> (Int, AssetsImage)
    func getPMWeatherInfo(dayInterval: Int) -> (Int, AssetsImage)
    func bindSevenDayAMWeatherImage(index: Int) -> AssetsImage
    func bindSevenDayPMWeatherImage(index: Int) -> AssetsImage
    
    var threeDaysForecastInfo: BehaviorRelay<VillageForecastBody?> { get }
    var sevenDaysForecastInfo: BehaviorRelay<SevenDayForecastInfoDataList?> { get }
}

public final class ForecastUseCase: ForecastUseCaseProtocol {
    private let forecastDataSource: ForecastDataSourceProtocol
    /// 3일간 예보 리스트
    public let threeDaysForecastInfo = BehaviorRelay<VillageForecastBody?>(value: nil)
    /// 7일간 예보 리스트
    public let sevenDaysForecastInfo = BehaviorRelay<SevenDayForecastInfoDataList?>(value: nil)
    
    public init(forecastDataSource: ForecastDataSourceProtocol) {
        self.forecastDataSource = forecastDataSource
        getThreeDaysForecastInfo()
    }
    
    // MARK: 데이터 받아오기
    /// 3일간 예보 받아오기
    @discardableResult
    public func getThreeDaysForecastInfo() -> Observable<VillageForecastInfoEntity> {
        return forecastDataSource.getVillageForcast()
            .map {
                self.threeDaysForecastInfo.accept($0.data)
                return $0
            }
            .asObservable()
    }
    
    /// 7일간 예보 받아오기
    @discardableResult
    public func getSevenDaysForecastInfo() -> Observable<SevenDayForecastInfoEntity> {
        return forecastDataSource.getTenDayForeCast()
            .map {
                self.sevenDaysForecastInfo.accept($0.data.list)
                return $0
            }
            .asObservable()
    }
    
    // MARK: 날씨 예보 공통 로직
    /// 어제 예보
    public func bindYesterdayWeather(selectedHour: String) -> [String: String] {
        bindWeatherByDate(dayInterval: -1, selectedHour: selectedHour)
    }
    /// 오늘 예보
    public func bindTodayWeather(selectedHour: String) -> [String: String] {
        bindWeatherByDate(dayInterval: 0, selectedHour: selectedHour)
    }
    /// 내일 예보
    public func bindTomorrowWeather(selectedHour: String) -> [String: String] {
        bindWeatherByDate(dayInterval: 1, selectedHour: selectedHour)
    }
    
    /// 지정된 날짜 예보 추출
    public func bindWeatherByDate(
        dayInterval: Int,
        selectedHour: String
    ) -> [String: String] {
        guard let data = threeDaysForecastInfo.value else { return [:] }
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        // 원하는 날짜 멥핑
        let todayForecast = data.list[selectedDate]?.forecasts
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        
        todayForecast?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let orderedByTimeCategories = timeToCategoryValue.sorted { $0.key < $1.key }
        
        // 현재시간인 카테고리 가져오기
        var categoryWithValue = ["":""]
        
        for key in orderedByTimeCategories {
            if key.key == selectedHour {
                // 카테고리 맵핑해서 저장하기
                
                categoryWithValue = key.value
                break
            }
        }
        
        return getExtremeTemp(categoryWithValue: categoryWithValue,
                              orderedByTimeCategories: orderedByTimeCategories,
                              selectedHour: selectedHour)
    }
    
    /// 최저/최고 기온 추출
    public func getExtremeTemp(
        categoryWithValue: [String: String],
        orderedByTimeCategories: [Dictionary<String, [String : String]>.Element],
        selectedHour: String
    ) -> [String: String] {
        let TMXTime = 15
        let TMNTime = 6
        var returnCategoryValues = categoryWithValue
        
        guard !orderedByTimeCategories.isEmpty else {
            return [:]
        }
        
        if selectedHour != "\(TMXTime)00" {
            for i in 0..<orderedByTimeCategories.count {
                if orderedByTimeCategories[i].key == "1500" {
                    let hasTMXDic = orderedByTimeCategories[i]
                    if let TMXValue = hasTMXDic.value["TMX"] {
                        returnCategoryValues.updateValue(TMXValue, forKey: "TMX")
                    }
                    break
                }
            }
        }
        
        if selectedHour != "0\(TMNTime)00" {
            for i in 0..<orderedByTimeCategories.count {
                if orderedByTimeCategories[i].key == "0600" {
                    let hasTMNDic = orderedByTimeCategories[i]
                    if let TMNValue = hasTMNDic.value["TMN"] {
                        returnCategoryValues.updateValue(TMNValue, forKey: "TMN")
                    }
                    break
                }
            }
        }
        
        return returnCategoryValues
    }
}

// MARK: 날씨 이미지 추출
extension ForecastUseCase {
    // MARK: 3일간 예보 관련
    /// 3일간 예보 오전 날씨 이미지 추출
    public func getAMWeatherInfo(dayInterval: Int) -> (Int, AssetsImage) {
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        let selectedForecasts = threeDaysForecastInfo.value?.list[selectedDate]?.forecasts
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        
        selectedForecasts?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let orderedByTimeCategories = timeToCategoryValue.sorted { $0.key < $1.key }
        var updatedCategory = ["":""]
        
        for i in 0..<orderedByTimeCategories.count {
            if orderedByTimeCategories[i].key == "0600" {
                updatedCategory.updateValue((orderedByTimeCategories[i].value["SKY"])!, forKey: "SKY")
                updatedCategory.updateValue((orderedByTimeCategories[i].value["PTY"])!, forKey: "PTY")
            }
            // 강수량 최대 업데이트 -> 40 넘으면 무조건 비 아이콘 , 강수량 표시
            // 40 안넘으면 06시, 18시의 skyStatus -> 맑음, 흐림
            if let rainPoP = orderedByTimeCategories[i].value["POP"] {
                if updatedCategory.index(forKey: "POP") == nil {
                    updatedCategory.updateValue(rainPoP, forKey: "POP")
                } else {
                    if Int(rainPoP)! > Int((updatedCategory["POP"])!)! {
                        updatedCategory.updateValue(rainPoP, forKey: "POP")
                    }
                }
            }
        }
        
        let yesterdayRainAMPos = Int((updatedCategory["POP"])!)!
        
        let outputImage = if yesterdayRainAMPos >= 40 {
            // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
            switch updatedCategory["PTY"] {
            case "1": AssetsImage.tenDayRain
            case "2": AssetsImage.tenDayRainSnow
            case "3": AssetsImage.tenDayRainSnow
            case "4": AssetsImage.tenDayRain
            default:  AssetsImage.tenDayRain
            }
        } else {
            // 맑음(1), 구름(3,4)
            switch updatedCategory["SKY"] {
            case "1": AssetsImage.tenDaySunny
            case "3",
                 "4": AssetsImage.tenDayAmCloud
            default:  AssetsImage.tenDaySunny
            }
        }
        
        return (yesterdayRainAMPos, outputImage)
    }
    
    /// 3일간 예보 오후 날씨 이미지 추출
    public func getPMWeatherInfo(dayInterval: Int) -> (Int, AssetsImage) {
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        let selectedForecasts = threeDaysForecastInfo.value?.list[selectedDate]?.forecasts
        
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        
        selectedForecasts?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let orderedByTimeCategories = timeToCategoryValue.sorted { $0.key < $1.key }
        var updatedCategory = ["":""]
        
        for i in 0..<orderedByTimeCategories.count {
            if orderedByTimeCategories[i].key == "1500" {
                updatedCategory.updateValue((orderedByTimeCategories[i].value["SKY"])!, forKey: "SKY")
                updatedCategory.updateValue((orderedByTimeCategories[i].value["PTY"])!, forKey: "PTY")
            }
            // 강수량 최대 업데이트 -> 40 넘으면 무조건 비 아이콘 , 강수량 표시
            // 40 안넘으면 06시, 18시의 skyStatus -> 맑음, 흐림
            if let rainPoP = orderedByTimeCategories[i].value["POP"] {
                if updatedCategory.index(forKey: "POP") == nil {
                    updatedCategory.updateValue(rainPoP, forKey: "POP")
                } else {
                    if Int(rainPoP)! > Int((updatedCategory["POP"])!)! {
                        updatedCategory.updateValue(rainPoP, forKey: "POP")
                    }
                }
            }
        }
        
        let yesterdayRainPMPos = Int((updatedCategory["POP"])!)!
        
        let outputImage = if yesterdayRainPMPos > 40 {
            // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
            switch updatedCategory["PTY"] {
            case "1": AssetsImage.tenDayRain
            case "2": AssetsImage.tenDayRainSnow
            case "3": AssetsImage.tenDayRainSnow
            case "4": AssetsImage.tenDayRain
            default:  AssetsImage.tenDayRain
            }
        } else {
            // 맑음(1), 구름(3,4)
            switch updatedCategory["SKY"] {
            case "1": AssetsImage.tenDaySunny
            case "3",
                 "4": AssetsImage.tenDayPmCloud
            default:  AssetsImage.tenDaySunny
            }
        }
        
        return (yesterdayRainPMPos, outputImage)
    }
    
    // MARK: 7일간 예보 관련
    /// 7일간 예보 오전 날씨 이미지 추출
    public func bindSevenDayAMWeatherImage(index: Int) -> AssetsImage {
        guard let sevenDayWeatherInfo = sevenDaysForecastInfo.value else { return AssetsImage.tenDayAmCloud }
        
        if (0...4).contains(index) {
            switch sevenDayWeatherInfo.weather[index].wfAm {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음",
                 "흐림":
                return AssetsImage.tenDayAmCloud
            case "구름많고 비",
                 "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈",
                 "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈",
                 "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기",
                 "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                if sevenDayWeatherInfo.weather[index].rnStAm ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin <= 0 {
                    return AssetsImage.tenDaySnow
                } else if sevenDayWeatherInfo.weather[index].rnStAm ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin >= 0 {
                    return AssetsImage.tenDayRain
                }
                return AssetsImage.tenDayAmCloud
            }
        } else {
            switch sevenDayWeatherInfo.weather[index].wf {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음",
                 "흐림":
                return AssetsImage.tenDayAmCloud
            case "구름많고 비",
                 "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈",
                 "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈",
                 "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기",
                 "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                if sevenDayWeatherInfo.weather[index].rnSt ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin <= 0 {
                    return AssetsImage.tenDaySnow
                } else if sevenDayWeatherInfo.weather[index].rnSt ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin >= 0 {
                    return AssetsImage.tenDayRain
                }
                return AssetsImage.tenDayAmCloud
            }
        }
    }
    
    /// 7일간 예보 오후 날씨 이미지 추출
    public func bindSevenDayPMWeatherImage(index: Int) -> AssetsImage {
        guard let sevenDayWeatherInfo = sevenDaysForecastInfo.value else { return AssetsImage.tenDayPmCloud }
        
        if (0...4).contains(index) {
            switch sevenDayWeatherInfo.weather[index].wfPm {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음",
                 "흐림":
                return AssetsImage.tenDayPmCloud
            case "구름많고 비",
                 "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈",
                 "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈",
                 "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기",
                 "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                if sevenDayWeatherInfo.weather[index].rnStPm ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin <= 0 {
                    return AssetsImage.tenDaySnow
                } else if sevenDayWeatherInfo.weather[index].rnStPm ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin >= 0 {
                    return AssetsImage.tenDayRain
                }
                return AssetsImage.tenDayPmCloud
            }
        } else {
            switch sevenDayWeatherInfo.weather[index].wf {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음",
                 "흐림":
                return AssetsImage.tenDayPmCloud
            case "구름많고 비",
                 "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈",
                 "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈",
                 "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기",
                 "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                if sevenDayWeatherInfo.weather[index].rnSt ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin <= 0 {
                    return AssetsImage.tenDaySnow
                } else if sevenDayWeatherInfo.weather[index].rnSt ?? 0 >= 60 && sevenDayWeatherInfo.temperature[index].taMin >= 0 {
                    return AssetsImage.tenDayRain
                }
                return AssetsImage.tenDayPmCloud
            }
        }
    }
}

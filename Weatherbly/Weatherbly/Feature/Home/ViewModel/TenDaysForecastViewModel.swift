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

class TenDaysForecastViewModel: RxBaseViewModel, ViewModelBusinessLogic {
    
    private var dataSource = ForecastDataSource()
    
    let villageForecastEntityRelay = BehaviorRelay<VillageForecastInfoEntity?>(value: nil)
    let yesterdayInfoRelay = BehaviorRelay<[String: String]?>(value: nil)
    let todayInfoRelay = BehaviorRelay<[String: String]?>(value: nil)
    let tomorrowInfoRelay = BehaviorRelay<[String: String]?>(value: nil)
    
    let sevenDayForecastInfoRelay = BehaviorRelay<SevenDayForecastInfoEntity?>(value: nil)
    let yesterdayRainAMPosRelay = BehaviorRelay<Int?>(value: 0)
    let yesterdayRainPMPosRelay = BehaviorRelay<Int?>(value: 0)
    
    init(_ villageForecastInfo: VillageForecastInfoEntity,_ yesterdayInfo: [String: String], _ todayInfo: [String: String], _ tomorrowInfo: [String: String] ) {
        self.yesterdayInfoRelay.accept(yesterdayInfo)
        self.todayInfoRelay.accept(todayInfo)
        self.tomorrowInfoRelay.accept(tomorrowInfo)
        self.villageForecastEntityRelay.accept(villageForecastInfo)
        super.init()
    }
    
    
    enum ThreeDayInfo {
        case yesterDayInfo
        case today
        case tomorrow
    }
    
    public func getInfo() {
        dataSource.getTenDayForeCast()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    self?.sevenDayForecastInfoRelay.accept(response)
                case .failure(let err):
                    guard let errString = err.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errString,
                                                         alertType: .Error,
                                                         closeAction: self?.popViewController))
                }
            })
            .disposed(by: bag)
    }
    
    
    func getAMWeatherImage(_ response: VillageForecastInfoEntity?, _ dayInterval: Int) -> AssetsImage? {
        
        var weatherImage: AssetsImage?
        guard response != nil else { return nil }
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        let selectedForecasts = response?.data!.list[selectedDate]!.forecasts
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        
        selectedForecasts?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let orderedByTimeCategories: [Dictionary<String, [String : String]>.Element]? = timeToCategoryValue.sorted { $0.key < $1.key }
        var updatedCategory: [String: String]? = [:]
        
        for i in 0..<(orderedByTimeCategories?.count)! {
            if orderedByTimeCategories?[i].key == "0600" {
                updatedCategory?.updateValue((orderedByTimeCategories?[i].value["SKY"])!, forKey: "SKY")
                updatedCategory?.updateValue((orderedByTimeCategories?[i].value["PTY"])!, forKey: "PTY")
            }
            // MARK: - 강수량 최대 업데이트 -> 40 넘으면 무조건 비 아이콘 , 강수량 표시
            // 40 안넘으면 06시, 18시의 skyStatus -> 맑음, 흐림
            if let rainPoP = orderedByTimeCategories?[i].value["POP"] {
                if updatedCategory?.index(forKey: "POP") == nil {
                    updatedCategory?.updateValue(rainPoP, forKey: "POP")
                } else {
                    if Int(rainPoP)! > Int((updatedCategory?["POP"])!)! {
                        updatedCategory?.updateValue(rainPoP, forKey: "POP")
                    }
                }
            }
        }
        
        yesterdayRainAMPosRelay.accept(Int((updatedCategory?["POP"])!)!)
        if Int((updatedCategory?["POP"])!)! >= 40 {
            switch updatedCategory?["PTY"] {
                // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
            case "1":
                weatherImage = AssetsImage.tenDayRain
            case "2":
                weatherImage = AssetsImage.tenDayRainSnow
            case "3":
                weatherImage = AssetsImage.tenDayRainSnow
            case "4":
                weatherImage = AssetsImage.tenDayRain
            default:
                
                weatherImage = AssetsImage.tenDayRain
            }
        } else {
            switch updatedCategory?["SKY"] {
            case "1":
                // WI -> 맑음
                weatherImage = AssetsImage.tenDaySunny
            case "3", "4":
                // WI -> 구름
                weatherImage = AssetsImage.tenDayAmCloud
            default:
                weatherImage = AssetsImage.tenDaySunny
                
            }
        }
        return weatherImage
    }
    
    
    func getPMWeatherImage(_ response: VillageForecastInfoEntity?, _ dayInterval: Int) -> AssetsImage? {
        
        var weatherImage: AssetsImage?
        guard response != nil else { return nil }
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        let selectedForecasts = response?.data!.list[selectedDate]!.forecasts
        
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        
        selectedForecasts?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let orderedByTimeCategories: [Dictionary<String, [String : String]>.Element]? = timeToCategoryValue.sorted { $0.key < $1.key }
        var updatedCategory: [String: String]? = [:]
        
        for i in 0..<(orderedByTimeCategories?.count)! {
            if orderedByTimeCategories?[i].key == "1500" {
                updatedCategory?.updateValue((orderedByTimeCategories?[i].value["SKY"])!, forKey: "SKY")
                updatedCategory?.updateValue((orderedByTimeCategories?[i].value["PTY"])!, forKey: "PTY")
            }
            // MARK: - 강수량 최대 업데이트 -> 40 넘으면 무조건 비 아이콘 , 강수량 표시
            // 40 안넘으면 06시, 18시의 skyStatus -> 맑음, 흐림
            if let rainPoP = orderedByTimeCategories?[i].value["POP"] {
                if updatedCategory?.index(forKey: "POP") == nil {
                    updatedCategory?.updateValue(rainPoP, forKey: "POP")
                } else {
                    if Int(rainPoP)! > Int((updatedCategory?["POP"])!)! {
                        updatedCategory?.updateValue(rainPoP, forKey: "POP")
                    }
                }
            }
            
            
        }
        
        yesterdayRainPMPosRelay.accept(Int((updatedCategory?["POP"])!)!)
        
        if Int((updatedCategory?["POP"])!)! > 40 {
            switch updatedCategory?["PTY"] {
                // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
            case "1":
                weatherImage = AssetsImage.tenDayRain
            case "2":
                weatherImage = AssetsImage.tenDayRainSnow
            case "3":
                weatherImage = AssetsImage.tenDayRainSnow
            case "4":
                weatherImage = AssetsImage.tenDayRain
            default:
                weatherImage = AssetsImage.tenDayRain
            }
        } else {
            switch updatedCategory?["SKY"] {
            case "1":
                // WI -> 맑음
                weatherImage = AssetsImage.tenDaySunny
                
            case "3", "4":
                // WI -> 구름
                weatherImage = AssetsImage.tenDayPmCloud
                
            default:
                break
            }
        }
        return weatherImage
    }
    
    func bindSevenDayAMWeatherImage(_ index: Int) -> AssetsImage {
        guard let sevenDayWeatherInfo = sevenDayForecastInfoRelay.value?.data.list else { return AssetsImage.tenDayAmCloud }
        
        if (3...7).contains(index) {
            switch sevenDayWeatherInfo.weather[index].wfAm {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음", "흐림":
                return AssetsImage.tenDayAmCloud
            case "구름많고 비", "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈", "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈", "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기", "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                return AssetsImage.tenDayAmCloud
                
            }
        } else {
            switch sevenDayWeatherInfo.weather[index].wf {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음", "흐림":
                return AssetsImage.tenDayAmCloud
            case "구름많고 비", "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈", "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈", "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기", "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                return AssetsImage.tenDayAmCloud
                
            }
        }
    }
        
    func bindSevenDayPMWeatherImage(_ index: Int) -> AssetsImage {
        guard let sevenDayWeatherInfo = sevenDayForecastInfoRelay.value?.data.list else { return AssetsImage.tenDayPmCloud }
        
        if (3...7).contains(index) {
            
            switch sevenDayWeatherInfo.weather[index].wfPm {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음", "흐림":
                return AssetsImage.tenDayPmCloud
            case "구름많고 비", "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈", "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈", "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기", "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                return AssetsImage.tenDayAmCloud
                
            }
        } else {
            switch sevenDayWeatherInfo.weather[index].wf {
            case "맑음":
                return AssetsImage.tenDaySunny
            case "구름많음", "흐림":
                return AssetsImage.tenDayPmCloud
            case "구름많고 비", "흐리고 비":
                return AssetsImage.tenDayRain
            case "구름많고 눈", "흐리고 눈":
                return AssetsImage.snow
            case "구름많고 비/눈", "흐리고 비/눈":
                return AssetsImage.tenDayRainSnow
            case "구름많고 소나기", "흐리고 소나기":
                return AssetsImage.tenDayRain
            default:
                return AssetsImage.tenDayAmCloud
                
            }
        }
    }
                
    private func popViewController() {
        navigationPopViewControllerRelay.accept(Void())
    }
}

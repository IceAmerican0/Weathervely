//
//  HomeViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    func toSettingView()
    func toDailyForecastView()
    func toTenDaysForecastView()
    func toSensoryTempView(_ selectedDate: String, _ selectedTime: String, _ selectedTemp: String, _ closetId: Int)
    func getInfo(_ dateString: String)
    func getVillageForecastInfo()
    func getRecommendCloset(_ dateString: String)
    func getSwipeArray()
    func swipeRight()
    func swipeLeft()

    func mainLabelTap()
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    
    private let getVillageDataSource = ForecastDataSource()
    private let getRecommendClosetDataSouce = ClosetDataSource()
    
    let villageForeCastInfoEntityRelay  = BehaviorRelay<VillageForecastInfoEntity?>(value: nil)
    let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetEntity?>(value: nil)
    let mappedCategoryDicRelay = BehaviorRelay<[String: String]?>(value: [:])
    
    var swipeArrayRelay = BehaviorRelay<[String]?>(value: nil)
    var swipeIndex = 0
    var swipeDirectionRelay = BehaviorRelay<UISwipeGestureRecognizer.Direction?>(value: .left)
    let headerTimeRelay = BehaviorRelay<String?>(value: Date().todayThousandFormat) // HH00
    let selectedHourParamTypeRelay = BehaviorRelay<String?>(value: Date().todayHourFormat) // 2023-08-11 16:00
    
    var highlightedCellIndexRelay = BehaviorRelay<Int>(value: 0)
    var highlightedClosetIdRelay = BehaviorRelay<Int>(value: 0)
    var weatherImageRelay = BehaviorRelay<UIImage?>(value: AssetsImage.weatherLoadingImage.image)
    var weatherMsgRelay = BehaviorRelay<String?>(value: "오늘 하루 어떠셨나요?")
    var yesterdayCategoryRelay = BehaviorRelay<[String: String]?>(value: nil)
    
    public func getInfo(_ dateString: String) {
        getVillageForecastInfo()
        getRecommendCloset(dateString)
        getSwipeArray()
    }
    
    public func getVillageForecastInfo() {
        
        let date = Date()
        
        getVillageDataSource.getVillageForcast()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    self?.villageForeCastInfoEntityRelay.accept(response)
                    
                    // 시간대로 묶은 카테고리
                    self?.mappedCategoryDicRelay.accept(self?.bindingWeatherByDate(response, 0, date.todayThousandFormat))
                    
                    lazy var yesterDayHour: String = {
                        var yesterDayHour = date.yesterdayThousandFormat
                        if yesterDayHour == "0000" || yesterDayHour == "0100" || yesterDayHour == "0200" {
                            yesterDayHour = "0300"
                            return yesterDayHour
                        }
                        return yesterDayHour
                    }()
                    self?.yesterdayCategoryRelay.accept(self?.bindingWeatherByDate(response, -1, yesterDayHour))
                    
                case .failure(let error):
                    debugPrint("viewModel Error : ", error.localizedDescription)
                    
                }
            })
            .disposed(by: bag)
    }
    
    public func getRecommendCloset(_ dateString: String) {
        getRecommendClosetDataSouce.getRecommendCloset(dateString)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    self?.recommendClosetEntityRelay.accept(response)
                case .failure(let error):
                    debugPrint("viewModel Error, getRecommendCloset :" , error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    func setCurrentIndex(_ index: Int) {
        guard self.recommendClosetEntityRelay.value != nil else { return }
        let closetInfo = self.recommendClosetEntityRelay.value?.data?.list.closets[index]
        if let closetId = closetInfo?.id {
            //                    debugPrint(index, closetId)
            highlightedClosetIdRelay.accept(closetId)
        }
    }
    
    func bindingWeatherByDate(_ response: VillageForecastInfoEntity?, _ dayInterval: Int, _ selectedHour: String) -> [String: String]? {
        
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        // 원하는 날짜 멥핑
        let todayForecast = response?.data!.list[selectedDate]!.forecasts
        let selectedHour = selectedHour // HH00
        
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        
        todayForecast?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        
        // 시간 오름차순
        let orderedByTimeCategories: [Dictionary<String, [String : String]>.Element]? = timeToCategoryValue.sorted { $0.key < $1.key }
        
        
        // 현재시간인 카테고리 가져오기
        var categoryWithValue: [String: String]? = [:]
        
        for key in orderedByTimeCategories! {
            if key.key == selectedHour {
                // 카테고리 맵핑해서 저장하기
                
                categoryWithValue = key.value
                break
            }
        }
        
        categoryWithValue = getExtremeTemp(categoryWithValue, orderedByTimeCategories, selectedHour)
        
        return categoryWithValue
    }
    
    func getExtremeTemp(_ categoryWithValue: [String: String]?, _ orderedByTimeCategories: [Dictionary<String, [String : String]>.Element]?, _ selectedHour: String) -> [String: String] {
        let TMXTime = 15
        let TMNTime = 6
        var returnCategoryValues: [String: String]? = categoryWithValue
        
        guard !orderedByTimeCategories!.isEmpty else {
            return [:]
        }
        
        if selectedHour != "\(TMXTime)00" {
            
            for key in orderedByTimeCategories![TMXTime].value {
                if key.key == "TMX" {
                    returnCategoryValues?.updateValue(key.value, forKey: key.key)
                }
            }
        }
        
        if selectedHour != "\(TMNTime)00" {
            for key in orderedByTimeCategories![TMNTime].value {
                if key.key == "TMN" {
                    returnCategoryValues?.updateValue(key.value, forKey: key.key)
                }
            }
        }
        return returnCategoryValues ?? [:]
    }
    
    func getWeatherImage(_ categoryValues: [String: String]?) {
        
        if !(categoryValues!.isEmpty) {
            let rainPossibility = Int(categoryValues!["POP"]!) ?? 0
            let rainForm = Int(categoryValues!["PTY"]!) ?? 0
            
            debugPrint(categoryValues!)
            // let numericPart = stringValue.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
            
            //            guard var rainfall: Double = {
            //                if (categoryValues!["PCP"] == "강수없음") {
            //                    return 0
            //                } else {
            //                    var rainfall = Double((categoryValues!["PCP"]?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!)
            //                    return rainfall
            //                }
            //            }() else { return }
            //
            //
            //            guard var snowfall: Double = {
            //                if(categoryValues!["SNO"] == "적설없음") {
            //                    return 0
            //                } else {
            //                    var snowfall = Double((categoryValues!["SNO"]?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!)
            //                    return snowfall
            //                }
            //            }() else { return }
            
            let skyStatus = Int(categoryValues!["SKY"]!) ?? 3
            let windSpeed = Double(categoryValues!["WSD"]!) ?? 0
            let humidity = Int(categoryValues!["REH"]!) ?? 0
            let temp = Int(categoryValues!["TMP"]!)!
            //            let maxTemp = categoryValues!["TMX"]
            //            let minTemp = categoryValues!["TMN"]
            
            
            var weatherImage: UIImage?
            var message = ""
            
            // TODO: - 메세지 필요
            switch rainPossibility {
            case 1...:
                if rainPossibility >= 40 {
                    switch rainForm {
                        // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
                    case 1:
                        weatherImage = AssetsImage.rainny.image
                        message = WeatherMsgEnum.currentRainMsg.msg
                    case 2:
                        // TODO: - 이미지 비/눈 변경
                        weatherImage = AssetsImage.rainsnow.image
                        message = WeatherMsgEnum.currrentRainSnowMsg.msg
                    case 3:
                        // TODO: - 이미지 눈 변경
                        weatherImage = AssetsImage.snow.image
                        message = WeatherMsgEnum.currentSnowMsg.msg
                    case 4:
                        // TODO: - 비 이미지 + 소나기 메세지
                        weatherImage = AssetsImage.rainny.image
                        message = WeatherMsgEnum.currenstShowerMsg.msg
                    default:
                        break
                    }
                    self.weatherImageRelay.accept(weatherImage)
                    
                    // message -> 비관련
                } else {
                    // 강수확률 0...40 일 때
                    self.noRainWeatherImageAndMessage(skyStatus, windSpeed, humidity, temp)
                }
            case ...0:
                self.noRainWeatherImageAndMessage(skyStatus, windSpeed, humidity, temp)
            default:
                break
            }
            
        }
    }
    
    func noRainWeatherImageAndMessage (_ skyStatus: Int, _ windSpeed: Double, _ humidity: Int, _ temp: Int) {
        
        var weatherImage: UIImage?
        var message = ""
        // TODO: -
        //         message -> ?
        if windSpeed >= 5.5 {
            weatherImage = AssetsImage.windy.image
            message = WeatherMsgEnum.strongWindMsg.msg
            self.weatherImageRelay.accept(weatherImage)
            self.weatherMsgRelay.accept(message)
            return
        } else if 3.4...5.4 ~= windSpeed {
            weatherImage = AssetsImage.windy.image
            message = WeatherMsgEnum.normalWindMsg.msg
            self.weatherImageRelay.accept(weatherImage)
            self.weatherMsgRelay.accept(message)
            return
        }
        
        if humidity <= 30 {
            message = WeatherMsgEnum.lowHumidity.msg
        } else if humidity >= 80 {
            message = WeatherMsgEnum.highHumidity.msg
        }
        switch skyStatus {
        case 1:
            // WI -> 맑음
            weatherImage = AssetsImage.sun.image
            if message.isEmpty && 60...70 ~= humidity && 15...20 ~= temp {
                message = WeatherMsgEnum.sunnyGoodMsg.msg
            } else {
                message = WeatherMsgEnum.sunnyNormalMsg.msg
            }
            
        case 3:
            // WI -> 구름
            weatherImage = AssetsImage.sunCloudy.image
            if message.isEmpty {
                message = [WeatherMsgEnum.cloudyMsg01.msg, WeatherMsgEnum.cloudyMsg02.msg].randomElement()!
            }
            // message -> 습도
        case 4:
            // WI -> 흐림
            weatherImage = AssetsImage.clouds.image
            if message.isEmpty {
                message = [WeatherMsgEnum.cloudyMsg01.msg, WeatherMsgEnum.cloudyMsg02.msg].randomElement()!
            }
            // message -> 습도
        default:
            break
        }
        self.weatherImageRelay.accept(weatherImage)
        self.weatherMsgRelay.accept(message)
    }
    
    public func getSwipeArray() {
        
        guard let now = headerTimeRelay.value else { return }
        
        var swipeArray: [String] = []
        var todayTimeArray = ["0700", "1500", "2000"]
        var tomorrowTimeArray = ["3100", "3900", "4400"]
        
        for i in todayTimeArray.indices {
            if now < todayTimeArray[i] {
                todayTimeArray.insert(now, at: i)
                for _ in 0..<i {
                    todayTimeArray.removeFirst()
                }
                break
            } else if now == todayTimeArray[i] {
                todayTimeArray.remove(at: i)
                todayTimeArray.insert(now, at: i)
                for _ in 0..<i {
                    todayTimeArray.removeFirst()
                }
                break
            } else {
                if i == todayTimeArray.count - 1 {
                    todayTimeArray.append(now)
                    for _ in 0...i {
                        todayTimeArray.removeFirst()
                    }
                } else {
                    continue
                }
            }
        }
        
        // TODO: - swipeIndex 를 구독해서 viewContorller 에서 사용할지는 생각해봐야한다.
        swipeIndex = (todayTimeArray.indices.filter { todayTimeArray[$0] == now })[0]
        
        todayTimeArray.map { swipeArray.append($0)}
        tomorrowTimeArray.map { swipeArray.append($0)}
        
        swipeArrayRelay.accept(swipeArray)
    }
    
    public func swipeLeft() {
        
        guard let forecastEntity = villageForeCastInfoEntityRelay.value,
              let swipeArray = swipeArrayRelay.value
        else { return }
        
        
        var categoryWithValue: [String: String]? = [:]
        var yesterdayCategoryValue: [String: String]? = [:]
        var headerTime: String = ""
        var selectedHour = selectedHourParamTypeRelay.value!
        
        if !(swipeIndex == swipeArray.count - 1) {
            swipeIndex += 1
            let time = Int(swipeArray[self.swipeIndex])!
            lazy var hour: String = {
                let hour = String(time)
                
                if hour.count == 1 {
                    return "0\(hour)00"
                } else if hour.count == 3{
                    return "0\(hour)"
                }
                return hour
            }()
            
            if time < 2400 {
                // 오늘
                selectedHour = hour
                self.selectedHourParamTypeRelay.accept(Date().todaySelectedFormat(selectedHour.addColon))
                categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, hour) // HH00
                
                if selectedHour == "0000" || selectedHour == "0100" || selectedHour == "0200" {
                    let newSelectedHour = "0300"
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newSelectedHour)
                } else {
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, hour)
                }
                
                headerTime = hour.hourToMainLabel
                
            } else {
                // 내일
                selectedHour = String(time - 2400)
                if String(time - 2400).count == 3 {
                    selectedHour = "0\(selectedHour)"
                }
                self.selectedHourParamTypeRelay.accept(Date().tomorrowSelectedFormat(selectedHour.addColon))
                categoryWithValue = self.bindingWeatherByDate(forecastEntity, 1, selectedHour)
                
                if selectedHour == "0000" || selectedHour == "0100" || selectedHour == "0200" {
                    let newSelectedHour = "0300"
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newSelectedHour)
                } else {
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, selectedHour)
                }
                
                headerTime = hour.hourToMainLabel
            }
            
            
            getRecommendCloset(selectedHourParamTypeRelay.value!)
            self.headerTimeRelay.accept(headerTime)
            self.mappedCategoryDicRelay.accept(categoryWithValue)
            self.yesterdayCategoryRelay.accept(yesterdayCategoryValue)
            
        } else {
            alertMessageRelay.accept(.init(title: "이후 시간은 확인할 수 없어요",
                                           alertType: .Info))
        }
    }
    
    public func swipeRight() {
        guard let forecastEntity = villageForeCastInfoEntityRelay.value,
              let swipeArray = swipeArrayRelay.value
        else { return }
        
        var categoryWithValue: [String: String]? = [:]
        var yesterdayCategoryValue: [String: String]? = [:]
        var headerTime: String = ""
        
        if !(swipeIndex == 0) {
            swipeIndex -= 1
            let time = Int(swipeArray[self.swipeIndex])!
            
            var selectedHour = selectedHourParamTypeRelay.value!
            lazy var hour: String = {
                let hour = String(time)
                
                if hour.count == 1 {
                    return "0\(hour)00"
                } else if hour.count == 3{
                    return "0\(hour)"
                }
                return hour
            }()
            
            if time < 2400 {
                // 오늘 안 시간일 때
                
                selectedHour = hour
                self.selectedHourParamTypeRelay.accept(Date().todaySelectedFormat(selectedHour.addColon))
                categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, hour) // HH00
                
                if selectedHour == "0000" || selectedHour == "0100" || selectedHour == "0200" {
                    let newSelectedHour = "0300"
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newSelectedHour)
                } else {
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, hour)
                }
                
                headerTime = hour.hourToMainLabel
                
            } else {
                
                selectedHour = String(time - 2400)
                if String(time - 2400).count == 3 {
                    selectedHour = "0\(selectedHour)"
                }
                
                self.selectedHourParamTypeRelay.accept(Date().tomorrowSelectedFormat(selectedHour.addColon))
                categoryWithValue = self.bindingWeatherByDate(forecastEntity, 1, selectedHour)
                
                if selectedHour == "0000" || selectedHour == "0100" || selectedHour == "0200" {
                    let newSelectedHour = "0300"
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newSelectedHour)
                } else {
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, selectedHour)
                }
                
                headerTime = hour.hourToMainLabel
                
            }
            
            getRecommendCloset(selectedHourParamTypeRelay.value!)
            self.headerTimeRelay.accept(headerTime)
            self.mappedCategoryDicRelay.accept(categoryWithValue)
            self.yesterdayCategoryRelay.accept(yesterdayCategoryValue)
        } else {
            alertMessageRelay.accept(.init(title: "현재보다 이전 시간은 확인할 수 없어요",
                                           alertType: .Info))
        }
    }
    
    public func mainLabelTap() {
        
        let date = Date()
        guard let forecastEntity  = villageForeCastInfoEntityRelay.value,
              let swipeArray = swipeArrayRelay.value
        else { return }
        
        var categoryWithValue: [String: String]? = [:]
        var yesterdayCategoryValue: [String: String]? = [:]
        
        var selectedTimeValue = selectedHourParamTypeRelay.value
        var selectedTime = selectedTimeValue.map { $0 }?.components(separatedBy: " ")
        var now = date.todayHourFormat
        var targetTime = "0700"
        var headerTime = ""
        
        if (selectedTime![0] == date.todayHourFormat.components(separatedBy: " ")[0]) { // 오늘 중 어떤시간이라도
            // 날씨, 옷, 헤더, 메세지 -> 내일 07시로
            selectedHourParamTypeRelay.accept(date.tomorrowSelectedFormat(targetTime.addColon))
            headerTime = targetTime.hourToMainLabel
            getRecommendCloset(selectedHourParamTypeRelay.value!)
            headerTimeRelay.accept("내일 \(headerTime)")
            categoryWithValue = self.bindingWeatherByDate(forecastEntity, 1, targetTime)
            
            if targetTime == "0000" || targetTime == "0100" || targetTime == "0200" {
                let newtargetTime = "0300"
                yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newtargetTime)
            } else {
                yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, targetTime)
            }
            
            yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, targetTime)
            swipeIndex = swipeArray.firstIndex(of: "3100")!
            
        } else { // 내일
            selectedHourParamTypeRelay.accept(date.todayHourFormat)
            targetTime = date.todayThousandFormat
            headerTime = date.todayThousandFormat.hourToMainLabel
            getRecommendCloset(selectedHourParamTypeRelay.value!)
            headerTimeRelay.accept(headerTime)
            categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, targetTime)
            
            if targetTime == "0000" || targetTime == "0100" || targetTime == "0200" {
                let newtargetTime = "0300"
                yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newtargetTime)
            } else {
                yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, targetTime)
            }
            
            yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, targetTime)
            swipeIndex = swipeArray.firstIndex(of: targetTime)!
        }
        self.mappedCategoryDicRelay.accept(categoryWithValue)
        self.yesterdayCategoryRelay.accept(yesterdayCategoryValue)
    }
    
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
    
    public func toSensoryTempView(_ selectedDate: String, _ selectedTime: String, _ selectedTemp: String, _ closetId: Int) {
        let vm = HomeSensoryTempViewModel(selectedDate, selectedTime, selectedTemp, closetId)
        let vc = HomeSensoryTempViewController(vm)
        vm.delegate = self
        vc.isModalInPresentation = true // prevent to dismiss the viewController when drag action
        presentViewControllerWithAnimationRelay.accept(vc)
    }
}

extension HomeViewModel: HomeSensoryTempViewControllerDelegate {
    func willDismiss() {
        let nickname = UserDefaultManager.shared.nickname
        
        self.getRecommendCloset(self.selectedHourParamTypeRelay.value!)
        self.alertMessageRelay.accept(.init(title: "\(nickname) 님의 체감온도가 반영되었어요", alertType: .Info))
    }
}

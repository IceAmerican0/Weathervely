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
    func setupDayChangeDetection()
    func secondsUntilNextDay() -> TimeInterval

    func mainLabelTap()
    func didEnterMall()
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    
    private let getVillageDataSource = ForecastDataSource()
    private let getClosetDataSource = ClosetDataSource()
    
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
    
    // 날짜변경, 시간변경을 알기 위한 relay
    let dayChangedRelay = PublishRelay<Void>()
    let hourChangedRelay = PublishRelay<Void>()
    
    override init() {
        super.init()
        setupDayChangeDetection()
        setupHourChangeDetection()
    }
    
    public func getInfo(_ dateString: String) {
        selectedHourParamTypeRelay.accept(Date().todayHourFormat)
        getVillageForecastInfo()
        getRecommendCloset(dateString)
        getSwipeArray()
        swipeIndex = 0
        headerTimeRelay.accept(Date().todayThousandFormat)
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
                case .failure(let err):
                    switch err {
                    case .noInternetError:
                        self?.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
                    default:
                        guard let errorDescription = err.errorDescription else { return }
                        self?.alertMessageRelay.accept(.init(title: errorDescription,
                                                             alertType: .Error,
                                                             closeAction: self?.popToSelf))
                    }
                }
            })
            .disposed(by: bag)
    }
    
    public func getRecommendCloset(_ dateString: String) {
        getClosetDataSource.getRecommendCloset(dateString)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    self?.recommendClosetEntityRelay.accept(response)
                case .failure(let err):
//                    switch err {
//                    case .noInternetError:
//                        self?.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
//                    default:
                        guard let errorDescription = err.errorDescription else { return }
                        self?.alertMessageRelay.accept(.init(title: errorDescription,
                                                             alertType: .Error,
                                                             closeAction: self?.popToSelf))
//                    }
                }
            })
            .disposed(by: bag)
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
            for i in 0..<orderedByTimeCategories!.count {
                if orderedByTimeCategories?[i].key == "1500" {
                    var hasTMXDic = orderedByTimeCategories?[i]
                    if let TMXValue = hasTMXDic?.value["TMX"] {
                        returnCategoryValues?.updateValue((hasTMXDic?.value["TMX"])!, forKey: "TMX")
                    }
                    break
                }
            }
        }

        
        if selectedHour != "0\(TMNTime)00" {
            for i in 0..<orderedByTimeCategories!.count {
                if orderedByTimeCategories?[i].key == "0600" {
                    var hasTMNDic = orderedByTimeCategories?[i]
                    if let TMNValue = hasTMNDic?.value["TMN"] {
                        returnCategoryValues?.updateValue((hasTMNDic?.value["TMN"])!, forKey: "TMN")
                    }
                    break
                }
            }
        }
        
        return returnCategoryValues ?? [:]
    }
    
    func getWeatherImage(_ categoryValues: [String: String]?) {
        
        if !(categoryValues!.isEmpty) {
            let rainPossibility = Int(categoryValues!["POP"]!) ?? 0
            let rainForm = Int(categoryValues!["PTY"]!) ?? 0
            
//            debugPrint(categoryValues!)
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
            let date = Date()
            
            switch rainPossibility {
            case 1...:
                if rainPossibility >= 40 {
                    switch rainForm {
                        // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
                    case 1:
                        weatherImage = AssetsImage.rainny.image
                        message = WeatherMsgEnum.futureRainMsg(rainPossibility).msg
                    case 2:
                        
                        weatherImage = AssetsImage.rainsnow.image
                        message = WeatherMsgEnum.futureRainSnowMsg(rainPossibility).msg
                    case 3:
                        
                        weatherImage = AssetsImage.snow.image
                        message = WeatherMsgEnum.futureSnowMsg(rainPossibility).msg
                    case 4:
                        
                        weatherImage = AssetsImage.rainny.image
                        message = WeatherMsgEnum.futureShowerMsg.msg
                    default:
                        break
                    }
                    self.weatherImageRelay.accept(weatherImage)
                    
                    if selectedHourParamTypeRelay.value != date.todayHourFormat {
                        self.weatherMsgRelay.accept(message)
                    }
                    
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
        let date = Date()
        var message = ""
        // FIXME: - 파라미터로 가지고 오지 말고 relay로 가져와서 멥핑해야 체감온도 이후 리로드할떄 메세지도 리로드 됨.
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
        
        if selectedHourParamTypeRelay.value != date.todayHourFormat {
            self.weatherMsgRelay.accept(message)
        }
        
    }
    
    public func getSwipeArray() {
        
//        guard let now = headerTimeRelay.value else { return }
        let now = Date().todayThousandFormat
        
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
            alertMessageRelay.accept(.init(title: "내일 날씨까지만 볼 수 있어요",
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
            let time = Int(swipeArray[self.swipeIndex])! // HH00
            let nowThousandHour = Date().todayThousandFormat

            lazy var hour: String = {
                let hour = String(time) // "700"
                
                if hour.count == 1 {
                    return "0\(hour)00" // 0000 한가지 케이스
                } else if hour.count == 3 {
                    return "0\(hour)"  // 10시 이전
                }
                return hour // HH00
            }()
            
            if time < 2400 {
                // 오늘 시간일 때
                
                if swipeIndex == 0 && hour != nowThousandHour { // MARK: - 1.배열의 첫번째를 바라보는데 현재 시간과 차이가 다를 때
                    
                    // 사용할 시간(현재시간) HH00 으로 바꿈
                    hour = nowThousandHour
                    headerTime = hour.hourToMainLabel // 헤더용 String으로 변환
                    
                    // 체감온도 파라미터로 넣어줄 시간 업데이트
                    self.selectedHourParamTypeRelay.accept(Date().todaySelectedFormat(hour.addColon))
                    
                    // swipeArray 데이터 업데이트
                    var newSwipeArrray = swipeArray
                    newSwipeArrray[self.swipeIndex] = hour // siwpeIndex = 0
                    swipeArrayRelay.accept(newSwipeArrray)
                    
                    // 오늘 날씨, 메세지 업데이트를 위한 바인딩
                    categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, hour)
                    
                    // 어제 온도 비교 라벨을 위한 어제 날씨Entity 바인딩
                    // 해당 시간에는 3시로 바인딩
                    if hour == "0000" || hour == "0100" || hour == "0200" { hour = "0300" }
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, hour)
                    
                } else {
                    // MARK: - 배열의 첫번째를 바라보지 않거나, 현재시간과 배열의 첫번째가 같을 때
                    headerTime = hour.hourToMainLabel
                    
                    self.selectedHourParamTypeRelay.accept(Date().todaySelectedFormat(hour.addColon))
                    categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, hour) // HH00
                    
                    if hour == "0000" || hour == "0100" || hour == "0200" { hour = "0300" }
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, hour)
                }
            } else {
                
                // 내일 중 어떤시간
                headerTime = hour.hourToMainLabel // hour = 3100, 3900, 4400
                
                hour = String(time - 2400) // hour = 0700, 1500, 2000
                if hour.count == 3 {
                    hour = "0\(hour)"
                }
                
                self.selectedHourParamTypeRelay.accept(Date().tomorrowSelectedFormat(hour.addColon))
                categoryWithValue = self.bindingWeatherByDate(forecastEntity, 1, hour)
                
                if hour == "0000" || hour == "0100" || hour == "0200" { hour = "0300" }
                    yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, hour)
                
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
        
        // FIXME: - 시간변화 걸쳐있을때 처리하기
        let date = Date()
        guard let forecastEntity  = villageForeCastInfoEntityRelay.value,
              let swipeArray = swipeArrayRelay.value
        else { return }
        
        var categoryWithValue: [String: String]? = [:]
        var yesterdayCategoryValue: [String: String]? = [:]
        
        let selectedTimeValue = selectedHourParamTypeRelay.value // yyyy-MM-dd HH:00
        let selectedDate = selectedTimeValue.map { $0 }?.components(separatedBy: " ") // ["2023-08-21", "17:00"]
        let now = date.todayHourFormat // yyyy-MM-dd HH:00
        var targetTime = "0700"
        var headerTime = ""
        
        if (selectedDate![0] == now.components(separatedBy: " ")[0]) { // -> 오늘 중 어떤시간이라도
            
            // 날씨, 옷, 헤더, 메세지 -> 내일 07시로
            selectedHourParamTypeRelay.accept(date.tomorrowSelectedFormat(targetTime.addColon))
            
            // 오전 7 시 // 보여주기 위한 String 값
            headerTime = targetTime.hourToMainLabel
            
            // 2023-to-morrow 07:00
            getRecommendCloset(selectedHourParamTypeRelay.value!)
            
            // 내일 오전 7시
            headerTimeRelay.accept("내일 \(headerTime)")
            
            // 미래 시간으로 가는 상황이니까 왼쪽 스와이프하면서 reload 되게 하기
            swipeDirectionRelay.accept(.left)
            categoryWithValue = self.bindingWeatherByDate(forecastEntity, 1, targetTime) // dialyWrapper 내일 07시 날씨로 reload
            yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, targetTime) // 어제 07시 가져와서 '어제(07시)보다 ''도 낮아요' 보여주기
            
            swipeIndex = swipeArray.firstIndex(of: "3100")!
            
        } else { // 내일 중 어느시간이라도
            
            // yyyy-MM-dd HH:00 날씨, 옷, 헤더, 메세지 -> 현재
            selectedHourParamTypeRelay.accept(now)
            
            // 현재 0000, 0100, 0200, 0300, 1200, 1500 ...
            targetTime = date.todayThousandFormat
            
            // 현재 00시 01시, 02시 ... 전부 현재로 return
            headerTime = targetTime.hourToMainLabel
            // date.todayHourFormat 즉, 현재 날짜와 현재 시간으로 api 전송
            getRecommendCloset(selectedHourParamTypeRelay.value!)
            
            // 전부 현재로 들어옴
            headerTimeRelay.accept(headerTime)
            
            swipeDirectionRelay.accept(.right)
            // dialyWrapper 현재 날씨로 reload
            categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, targetTime)
            
            if targetTime == "0000" || targetTime == "0100" || targetTime == "0200" {
                let newtargetTime = "0300"
                yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, newtargetTime)
            } else {
                yesterdayCategoryValue = self.bindingWeatherByDate(forecastEntity, -1, targetTime)
            }
            
            swipeIndex = swipeArray.firstIndex(of: targetTime)!
        }
        self.mappedCategoryDicRelay.accept(categoryWithValue)
        self.yesterdayCategoryRelay.accept(yesterdayCategoryValue)
    }
    
    public func didEnterMall() {
        getClosetDataSource.pagerViewClicked(highlightedClosetIdRelay.value)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    break
                case .failure(let err):
                    guard let errString = err.errorDescription else { return }
                    #if DEBUG
                    print(errString)
                    #endif
                    break
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - DayChange
    
    public func setupDayChangeDetection() {
        // 첫 번째 파라미터는 초기 지연 시간, 두 번째 파라미터는 이후 반복될 시간 간격
        Observable<Int>.timer(RxTimeInterval.seconds(Int(secondsUntilNextDay())), scheduler: MainScheduler.instance)
            .take(1)  // 한 번만 실행하기 위해 take(1)을 사용합니다.
            .subscribe(onNext: { [weak self] _ in
                // 날짜가 바뀌면 dayChangedRelay를 통해 알림
                self?.dayChangedRelay.accept(())

                // 다음 날짜 변경을 위한 새로운 타이머를 설정
                self?.setupDayChangeDetection()
            })
            .disposed(by: bag)
    }
    
    
    public func secondsUntilNextDay() -> TimeInterval {
        let calendar = Calendar.shared
        let now = Date()
        
        // 오늘 날짜 기준으로 내일의 날짜를 얻습니다.
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else {
            return 0
        }
        
        // 내일의 00:00 (자정) 시간 가져오기
        let midnightTomorrow = calendar.startOfDay(for: tomorrow)
        
        // 현재 시간과 내일 자정 사이의 시간 간격을 초 단위로 반환합니다.
        return midnightTomorrow.timeIntervalSince(now)
    }
    
    // MARK: - HourChange

    func setupHourChangeDetection() {

        Observable<Int>.timer(RxTimeInterval.seconds(Int(secondsUntilNextHour())), scheduler: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                
                let calendar = Calendar.shared
                let now = Date()
                let currentHour = calendar.component(.hour, from: now)
                // 현재 시간이 00시가 아닐 때만 hourChangedRelay를 트리거합니다.
                if currentHour != 0 {
                    self?.hourChangedRelay.accept(())
                }
                self?.setupHourChangeDetection()
            })
            .disposed(by: bag)
    }
    
    func secondsUntilNextHour() -> TimeInterval {
        let calendar = Calendar.shared
           let now = Date()
           
           // 현재 시간의 시와 분을 가져옵니다.
        _ = calendar.component(.hour, from: now)
           let currentMinute = calendar.component(.minute, from: now)
           let currentSecond = calendar.component(.second, from: now)
           
           // 다음 정각까지 남은 시간을 초로 계산합니다.
           let remainingSeconds = 3600 - (currentMinute * 60 + currentSecond)
            
           return TimeInterval(remainingSeconds)
    }
    
    
    func setCurrentIndex(_ index: Int) {
        guard self.recommendClosetEntityRelay.value != nil else { return }
        let closetInfo = self.recommendClosetEntityRelay.value?.data?.list.closets[index]
        if let closetId = closetInfo?.id {
            highlightedClosetIdRelay.accept(closetId)
        }
    }
    
    func setCurrentMsg() {
        guard let newTemperatureDiff = self.recommendClosetEntityRelay.value?.data?.list.temperatureDifference else { return }
        if selectedHourParamTypeRelay.value == Date().todayHourFormat {
            self.weatherMsgRelay.accept(WeatherMsgEnum.seonsoryDiffMsg(newTemperatureDiff).msg)
        }
        
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
        guard let villageForecastInfo = villageForeCastInfoEntityRelay.value else { return }
        
        guard let yesterDayInfo = yesterdayCategoryRelay.value else { return }
        guard let todayInfo = mappedCategoryDicRelay.value else { return }
        guard let tomorrowInfo = bindingWeatherByDate(villageForecastInfo, 1, Date().tomorrowThousandFormat) else { return }
        
    
        
        let vc = TenDaysForeCastViewController(TenDaysForecastViewModel(villageForecastInfo, yesterDayInfo, todayInfo, tomorrowInfo))
        navigationPushViewControllerRelay.accept(vc)
    }
    
    
    public func toSensoryTempView(_ selectedDate: String, _ selectedTime: String, _ selectedTemp: String, _ closetId: Int) {
        let vm = HomeSensoryTempViewModel(selectedDate, selectedTime, selectedTemp, closetId)
        let vc = HomeSensoryTempViewController(vm)
        vm.delegate = self
        vc.isModalInPresentation = true // prevent to dismiss the viewController when drag action
        presentViewControllerWithAnimationRelay.accept(vc)
    }
    
    private func popToSelf() {
        navigationPopToSelfRelay.accept(Void())
    }
}

extension HomeViewModel: HomeSensoryTempViewControllerDelegate {
    func willDismiss() {
        let nickname = UserDefaultManager.shared.nickname
        
        self.getRecommendCloset(self.selectedHourParamTypeRelay.value!)
        let newTemperatureDiff = self.recommendClosetEntityRelay.value?.data?.list.temperatureDifference
        self.weatherMsgRelay.accept(WeatherMsgEnum.seonsoryDiffMsg(newTemperatureDiff!).msg)
        self.alertMessageRelay.accept(.init(title: "\(nickname) 님의 체감온도가 반영됐어요", alertType: .Info))
    }
}

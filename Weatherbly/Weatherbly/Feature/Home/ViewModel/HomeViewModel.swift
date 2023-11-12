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
    func toDailyForecastView()
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
    private let closetDataSource: ClosetDataSourceProtocol
    private let forecastUseCase: ForecastUseCaseProtocol
    
    let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetBody?>(value: nil)
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
    
    init(
        closetDataSource: ClosetDataSourceProtocol,
        forecastUseCase: ForecastUseCaseProtocol
    ) {
        self.closetDataSource = closetDataSource
        self.forecastUseCase = forecastUseCase
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
        
        forecastUseCase.getThreeDaysForecastInfo()
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    // 시간대로 묶은 카테고리
                    owner.mappedCategoryDicRelay.accept(
                        owner.forecastUseCase.bindTodayWeather(
                            selectedHour: date.todayThousandFormat
                    ))
                    
                    owner.yesterdayCategoryRelay.accept(
                        owner.forecastUseCase.bindYesterdayWeather(
                            selectedHour: date.yesterdayThousandFormat
                    ))
                },
                onError: { owner, error in
                    owner.alertMessageRelay.accept(.init(title: error.localizedDescription,
                                                         alertType: .Error,
                                                         closeAction: owner.popToSelf))
            })
            .disposed(by: bag)
    }
    
    public func getRecommendCloset(_ dateString: String) {
        closetDataSource.getRecommendCloset(dateString)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.recommendClosetEntityRelay.accept(response.data?.list)
                },
                onError: { owner, error in
                    owner.alertMessageRelay.accept(.init(title: error.localizedDescription,
                                                         alertType: .Error,
                                                         closeAction: owner.popToSelf))
            })
            .disposed(by: bag)
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
    
    func noRainWeatherImageAndMessage (_ skyStatus: Int,
                                       _ windSpeed: Double,
                                       _ humidity: Int,
                                       _ temp: Int
    ) {
        var weatherImage: UIImage?
        let date = Date()
        var message = ""
        
        if windSpeed >= 5.5 {
            self.weatherImageRelay.accept(AssetsImage.windy.image)
            self.weatherMsgRelay.accept(WeatherMsgEnum.strongWindMsg.msg)
            return
        } else if 3.4...5.4 ~= windSpeed {
            self.weatherImageRelay.accept(AssetsImage.windy.image)
            self.weatherMsgRelay.accept(WeatherMsgEnum.normalWindMsg.msg)
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
        let now = Date().todayThousandFormat
        var swipeArray: [String] = []
        var todayTimeArray = ["0700", "1500", "2000"]
        let tomorrowTimeArray = ["3100", "3900", "4400"]
        
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
        guard let swipeArray = swipeArrayRelay.value else { return }
        var categoryWithValue = ["":""]
        var yesterdayCategoryValue = ["":""]
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
                categoryWithValue = forecastUseCase.bindTodayWeather(
                    selectedHour: hour
                )
                
                yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                    selectedHour: selectedHour.forecastValidTime
                )
                
                headerTime = hour.hourToMainLabel
                
            } else {
                // 내일
                selectedHour = String(time - 2400)
                if String(time - 2400).count == 3 {
                    selectedHour = "0\(selectedHour)"
                }
                
                selectedHourParamTypeRelay.accept(Date().tomorrowSelectedFormat(selectedHour.addColon))
                categoryWithValue = forecastUseCase.bindTomorrowWeather(
                    selectedHour: selectedHour
                )
                
                yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                    selectedHour: selectedHour.forecastValidTime
                )
                
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
        guard let swipeArray = swipeArrayRelay.value else { return }
        var categoryWithValue = ["":""]
        var yesterdayCategoryValue = ["":""]
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
                    categoryWithValue = forecastUseCase.bindTodayWeather(
                        selectedHour: hour
                    )
                    // 어제 온도 비교 라벨을 위한 어제 날씨Entity 바인딩
                    // 해당 시간에는 3시로 바인딩
                    yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                        selectedHour: hour.forecastValidTime
                    )
                } else {
                    // MARK: - 배열의 첫번째를 바라보지 않거나, 현재시간과 배열의 첫번째가 같을 때
                    headerTime = hour.hourToMainLabel
                    
                    self.selectedHourParamTypeRelay.accept(Date().todaySelectedFormat(hour.addColon))
                    categoryWithValue = forecastUseCase.bindTodayWeather(
                        selectedHour: hour
                    )
                    yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                        selectedHour: hour.forecastValidTime
                    )
                }
            } else {
                
                // 내일 중 어떤시간
                headerTime = hour.hourToMainLabel // hour = 3100, 3900, 4400
                
                hour = String(time - 2400) // hour = 0700, 1500, 2000
                if hour.count == 3 {
                    hour = "0\(hour)"
                }
                
                self.selectedHourParamTypeRelay.accept(Date().tomorrowSelectedFormat(hour.addColon))
                categoryWithValue = forecastUseCase.bindTodayWeather(
                    selectedHour: hour
                )
                yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                    selectedHour: hour.forecastValidTime
                )
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
        guard let swipeArray = swipeArrayRelay.value else { return }
        var categoryWithValue = ["":""]
        var yesterdayCategoryValue = ["":""]
        
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
            
            // dailyWrapper 내일 07시 날씨로 reload
            categoryWithValue = forecastUseCase.bindTomorrowWeather(
                selectedHour: targetTime
            )
            // 어제 07시 가져와서 '어제(07시)보다 ''도 낮아요' 보여주기
            yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                selectedHour: targetTime
            )
            
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
            categoryWithValue = forecastUseCase.bindTodayWeather(
                selectedHour: targetTime
            )
            
            yesterdayCategoryValue = forecastUseCase.bindYesterdayWeather(
                selectedHour: targetTime.forecastValidTime
            )
            
            swipeIndex = swipeArray.firstIndex(of: targetTime) ?? 0
        }
        self.mappedCategoryDicRelay.accept(categoryWithValue)
        self.yesterdayCategoryRelay.accept(yesterdayCategoryValue)
    }
    
    public func didEnterMall() {
        closetDataSource.pagerViewClicked(highlightedClosetIdRelay.value)
            .subscribe(
                with: self,
                onNext: { _, _ in
                    return
                },
                onError: { _, error in
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                    return
            })
            .disposed(by: bag)
    }
    
    // MARK: - DayChange
    public func setupDayChangeDetection() {
        // 첫 번째 파라미터는 초기 지연 시간, 두 번째 파라미터는 이후 반복될 시간 간격
        Observable<Int>.timer(RxTimeInterval.seconds(Int(secondsUntilNextDay())), scheduler: MainScheduler.instance)
            .take(1)  // 한 번만 실행하기 위해 take(1)을 사용합니다.
            .bind(with: self) { owner, _ in
                // 날짜가 바뀌면 dayChangedRelay를 통해 알림
                owner.dayChangedRelay.accept(())

                // 다음 날짜 변경을 위한 새로운 타이머를 설정
                owner.setupDayChangeDetection()
            }
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
            .bind(with: self) { owner, _ in
                let calendar = Calendar.shared
                let now = Date()
                let currentHour = calendar.component(.hour, from: now)
                // 현재 시간이 00시가 아닐 때만 hourChangedRelay를 트리거합니다.
                if currentHour != 0 {
                    owner.hourChangedRelay.accept(())
                }
                owner.setupHourChangeDetection()
            }
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
        guard let list = recommendClosetEntityRelay.value else { return }
        let closetInfo = list.closets[index]
        highlightedClosetIdRelay.accept(closetInfo.id)
    }
    
    func setCurrentMsg() {
        guard let newTemperatureDiff = recommendClosetEntityRelay.value?.temperatureDifference else { return }
        if selectedHourParamTypeRelay.value == Date().todayHourFormat {
            self.weatherMsgRelay.accept(WeatherMsgEnum.sensoryDiffMsg(newTemperatureDiff).msg)
        }
    }
    
    public func toDailyForecastView() {
        let vc = DailyForecastViewController(EmptyViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toSensoryTempView(
        _ selectedDate: String,
        _ selectedTime: String,
        _ selectedTemp: String,
        _ closetId: Int
    ) {
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
        let newTemperatureDiff = recommendClosetEntityRelay.value?.temperatureDifference
        self.weatherMsgRelay.accept(WeatherMsgEnum.sensoryDiffMsg(newTemperatureDiff!).msg)
        self.alertMessageRelay.accept(.init(title: "\(nickname) 님의 체감온도가 반영됐어요", alertType: .Info))
    }
}

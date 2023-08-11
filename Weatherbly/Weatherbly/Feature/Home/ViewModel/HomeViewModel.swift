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

public enum HomeViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    func toSettingView()
    func toDailyForecastView()
    func toTenDaysForecastView()
    func toSensoryTempView(_ selectedDate: String)
    func getInfo(_ dateString: String)
    func getVillageForecastInfo()
    func getRecommendCloset(_ dateString: String)
    func getSwipeArray()
    func swipeRight(_ dayInterval: Int)
    func swipeLeft()
    var viewAction: PublishRelay<HomeViewAction> { get }
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    
    public var viewAction: RxRelay.PublishRelay<HomeViewAction>
    
    private let getVilageDataSource = ForecastDataSource()
    private let getRecommendClosetDataSouce = ClosetDataSource()
    
    let villageForeCastInfoEntityRelay  = BehaviorRelay<VillageForecastInfoEntity?>(value: nil)
    let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetEntity?>(value: nil)
    let mappedCategoryDicRelay = BehaviorRelay<[String: String]?>(value: [:])
    
    var swipeArrayRealy = BehaviorRelay<[String]?>(value: nil)
    var swipeIndex = 0
    // TODO: - 필요한거 없는지 확인하기
    let chageDateTimeRelay = BehaviorRelay<[String]?>(value: nil)
    let headerTimeRelay = BehaviorRelay<String?>(value: Date().today24Time) // HH00
    let selectedHourParamTypeRelay = BehaviorRelay<String?>(value: Date().todayParamType) // 2023-08-11 16:00
    
    var highlightedCellIndexRelay = BehaviorRelay<Int>(value: 0)
    var weatherImageRelay = BehaviorRelay<UIImage?>(value: AssetsImage.weatherLoadingImage.image)
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func getInfo(_ dateString: String) {
        getVillageForecastInfo()
        getRecommendCloset(dateString)
        getSwipeArray()
    }
    
    public func getVillageForecastInfo() {
        
        getVilageDataSource.getVilageForcast()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    self?.villageForeCastInfoEntityRelay.accept(response)
                    
                    // 시간대로 묶은 카테고리
                    self?.mappedCategoryDicRelay.accept(self?.bindingWeatherByDate(response, 0, Date().today24Time))
                case .failure(let error):
                    print("viewModel Error : ", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    public func getRecommendCloset(_ dateString: String) {
        // TODO: - 시간 파라미터로 받기
//        let date = Date()
//        let dateFormmater = DateFormatter.shared
//        dateFormmater.dateFormat = "yyyy-MM-dd HH:00"
//        print(dateFormmater.string(from: date))
        print("dateString, ", dateString)
        getRecommendClosetDataSouce.getRecommendCloset(dateString)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let respone):
                    self?.recommendClosetEntityRelay.accept(respone)
                    print("result success")
                case .failure(let error):
                    print("viewModel Error, getRecommendCloset :" , error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    
    func bindingWeatherByDate(_ response: VillageForecastInfoEntity?, _ dayInterval: Int, _ selectedHour: String) -> [String: String]? {
        
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        // 원하는 날짜 멥핑
        let todayForecast = response?.data!.list[selectedDate]!.forecasts
        
        let selectedHour = selectedHour
        
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
            let rainPossibility = Int(categoryValues!["POP"]!)!
            let rainForm = Int(categoryValues!["PTY"]!)
            
            
            // let numericPart = stringValue.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

            guard var rainfall: Double = {
                if (categoryValues!["PCP"] == "강수없음") {
                    return 0
                } else {
                    var rainfall = Double((categoryValues!["PCP"]?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!)
                    return rainfall
                }
            }() else { return }
            
            
            guard var snowfall: Double = {
                if(categoryValues!["SNO"] == "적설없음") {
                    return 0
                } else {
                    var snowfall = Double((categoryValues!["SNO"]?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!)
                    return snowfall
                }
            }() else { return }
            
            let skyStatus = Int(categoryValues!["SKY"]!)!
//            let windSpeed = categoryValues!["WSD"]
//
//            let humidity = categoryValues!["REH"]
//            let temp = categoryValues!["TMP"]
//            let maxTemp = categoryValues!["TMX"]
//            let minTemp = categoryValues!["TMN"]
            

            var weatherImage: UIImage?
            var message = ""
            
            switch rainPossibility {
                
                /// 강수 확률 있는 경우
                /// 강수 형태가 눈일수도 있기때문에 강수형태도 고려해야한다.
                // TODO: - 메세지 필요
                case 1...:
                    if rainPossibility >= 40 {
                        switch rainForm {
                        // (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)
                        case 1:
                            weatherImage = AssetsImage.rainnyImage.image
                            self.weatherImageRelay.accept(weatherImage)
                        case 2:
                            // TODO: - 이미지 비/눈 변경
                            weatherImage = AssetsImage.rainnyImage.image
                            self.weatherImageRelay.accept(weatherImage)
                        case 3:
                            // TODO: - 이미지 눈 변경
                            weatherImage = AssetsImage.rainnyImage.image
                            self.weatherImageRelay.accept(weatherImage)
                        case 4:
                            // TODO: - 비 이미지 + 소나기 메세지
                            weatherImage = AssetsImage.rainnyImage.image
                            self.weatherImageRelay.accept(weatherImage)
                        default:
                            break
                        }
                        
                        // message -> 비관련
                    } else {
                        // 강수확률 0...40 일 때
                        self.noRainWeatherImage(skyStatus)
                    }
                case ...0:
                    self.noRainWeatherImage(skyStatus)
                default:
                    break
                }
            
//            print(categoryValues!)
        }
    }
    
    func noRainWeatherImage (_ skyStatus: Int) {
        
        var weatherImage: UIImage?
        // TODO: -
        // WI -> ?
        // rainForm 확인 -> 눈 ? 비 ?
        // message -> ?
        
        switch skyStatus {
        case 1:
            // WI -> 맑음
            weatherImage = AssetsImage.sunnyImage.image
            self.weatherImageRelay.accept(weatherImage)
            // message -> 습도, 풍속
        case 3:
            // WI -> 구름
            weatherImage = AssetsImage.cloudyImage.image
            self.weatherImageRelay.accept(weatherImage)
            // message -> 습도, 풍속
        case 4:
            // WI -> 흐림
            weatherImage = AssetsImage.blurCloudImage.image
            self.weatherImageRelay.accept(weatherImage)
            // message -> 습도, 풍속
        default:
            print(3)
        }
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
        
        print(todayTimeArray)
        // TODO: - swipeIndex 를 구독해서 viewContorller 에서 사용할지는 생각해봐야한다.
        swipeIndex = (todayTimeArray.indices.filter { todayTimeArray[$0] == now })[0]
        
        todayTimeArray.map { swipeArray.append($0)}
        tomorrowTimeArray.map { swipeArray.append($0)}
        print(swipeArray)
        swipeArrayRealy.accept(swipeArray)
    }
    
    public func swipeLeft() {
        
        /// 1. 현재시간 가져오기
        /// 2. 현재시간 보다 작으면 아무액션 없기.
        /// 3. 시간 배열 들고있기.
        /// ex) 현재 시간 10시. 왼쪽으로는 swipe못함.
        ///현재시간 23시 오른쪽으로 스와이프하면 내일 날씨.
        
        // 00시 ~ 06시 : 현재, 07, 15, 20 , 내일 07, 15, 20시
        // 07시 : 현재 , 15, 20 , 내일 07, 15, 20
        // 08 ~ 14 : 현재 , 15, 20 , 내일 07, 15, 20
        // 15 : 현재, 20, 내일 07, 15, 20
        // 20 ~ 23 : 현재 , 내일 07, 15, 20
        
        guard let forecastEntity = villageForeCastInfoEntityRelay.value,
              let swipeArray = swipeArrayRealy.value,
              let now = headerTimeRelay.value
        else { return }
        var categoryWithValue: [String: String]? = [:]
        var headerTime: String = ""
        
        if !(swipeIndex == swipeArray.count - 1) {
            swipeIndex += 1
            if Int(swipeArray[self.swipeIndex])! < 2400 {
                 categoryWithValue = self.bindingWeatherByDate(forecastEntity, 0, swipeArray[self.swipeIndex])
                
            } else {
                lazy var hour: String = {
                  
                    var hour = String((Int(swipeArray[self.swipeIndex])! - 2400))
                    if hour.count == 3 {
                        return "0\(hour)"
                    } else {
                        return hour
                    }
                    
                }()
                
                categoryWithValue = self.bindingWeatherByDate(forecastEntity, 1, hour)
                headerTime = hour
            }
            
            headerTime = headerTime.hourToMain
            
            self.mappedCategoryDicRelay.accept(categoryWithValue)
            self.headerTimeRelay.accept(headerTime)
            
        } else {
            // Show toast
        }
        
        
    }
    
    public func swipeRight(_ dayInterval: Int) {
        self.headerTimeRelay.accept("현재")
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
    
    public func toSensoryTempView(_ selectedDate: String) {
        let vc = HomeSensoryTempViewController(HomeSensoryTempViewModel(selectedDate))
        vc.isModalInPresentation = true // prevent to dismiss the viewController when drag action 
        presentViewControllerWithAnimationRelay.accept(vc)
    }

    
}

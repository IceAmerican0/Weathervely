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
    func swipeRight(_ dayInterval: Int) -> [String : String?]?
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
    let chageDateTimeRelay = BehaviorRelay<[String]?>(value: nil)
    
    
    let selectedJustHourRelay = BehaviorRelay<String?>(value: Date().today24Time)
    let selectedHourParamTypeRelay = BehaviorRelay<String?>(value: Date().todayParamType)
    
    var highlightedCellIndexRelay = BehaviorRelay<Int>(value: 0)
    var weatherImageRelay = BehaviorRelay<UIImage?>(value: AssetsImage.weatherLoadingImage.image)
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func getInfo(_ dateString: String) {
        getVillageForecastInfo()
        getRecommendCloset(dateString)
    }
    
    public func getVillageForecastInfo() {
        
        getVilageDataSource.getVilageForcast()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    
                    /// 시간대 변경 swipe할 때 마다 날짜와 시간을 준다.
                    /// 파라미터로받은 시간, 날짜로 맵핍을 하면 self?.bindingDateWeather(response, 0) 카테고리만 걸러진다.
                    /// 문제는 파라미터로 response를 받을 수 없다는 점.
                    /*
                     카테고리만 걸러내려면 필요한 것
                     1. 날짜
                     2. 시간
                     3. 맵핑할 response data
                     =====================
                     Swipe시 넘겨 줄 수 있나?
                     1. 가능
                     2. 가능
                     3. 다시 쏴야함...or 가지고 있어야한다.. 어디에?
                     */
                    
                    self?.villageForeCastInfoEntityRelay.accept(response)
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
        
        getRecommendClosetDataSouce.gerRecommendCloset(dateString)
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
            print(0)
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
                print(3)
                    self.noRainWeatherImage(skyStatus)
                default:
                print(4)
                    break
                }
            
            print(categoryValues!)
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
    
    
    public func swipeRight(_ dayInterval: Int) -> [String: String?]? {
        
        /// 1. 현재시간 가져오기
        /// 2. 현재시간 보다 작으면 아무액션 없기.
        /// 3. 시간 배열 들고있기.
        ///
        /// [ 0700, 0900, 1200, 1500, 1800, 2100 ]
        ///
        ///
        ///ex) 현재 시간 10시. 왼쪽으로는 swipe못함.
        ///현재시간 23시 오른쪽으로 스와이프하면 내일 날씨.

        let date = Date()
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        var timeArray = [ "0700", "0900", "1200", "1500", "1800", "2100" ]
        
        for time in timeArray {
            if time > selectedJustHourRelay.value! {
                selectedJustHourRelay.accept(time) // HH00
                selectedHourParamTypeRelay.accept("\(dateFormatter.string(from: date)) \(time.addColon)") // param format date
                break
            }
//            else if {
//
//            }
        }
        
        guard let weatherInfo = self.villageForeCastInfoEntityRelay.value else { return [:] }
        
        
        return [:]
    }
    
    public func swipeLeft() {
        
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

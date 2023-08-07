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

public enum HomeViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    func toSettingView()
    func toDailyForecastView()
    func toTenDaysForecastView()
    func didTapClosetCell()
    var viewAction: PublishRelay<HomeViewAction> { get }
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    
    public var viewAction: RxRelay.PublishRelay<HomeViewAction>
    
    private let getVilageDataSource = ForecastDataSource()
    private let getRecommendClosetDataSouce = ClosetDataSource()
    //    let villageForeCastInfoEntityRelay  = BehaviorRelay<[String: String?]?>(value: [:])
    let villageForeCastInfoEntityRelay  = BehaviorRelay<VillageForecastInfoEntity?>(value: nil)
    let mappedCategoryDicRelay = BehaviorRelay<[String: String]?>(value: [:])
    let chageDateTimeRelay = BehaviorRelay<[String]?>(value: nil)
    let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetEntity?>(value: nil)
    
    
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    func getInfo() {
        getVillageForecastInfo()
        getRecommendCloset()
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
                    self?.mappedCategoryDicRelay.accept(self?.bindingDateWeather(response, 0, Date().today24Time))
                case .failure(let error):
                    print("viewModel Error : ", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    private func getRecommendCloset() {
        
        let date = Date()
        let dateFormmater = DateFormatter.shared
        dateFormmater.dateFormat = "yyyy-MM-dd HH:00"
        print(dateFormmater.string(from: date))
        
        getRecommendClosetDataSouce.gerRecommendCloset(dateFormmater.string(from: date))
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
    
    
    func bindingDateWeather(_ response: VillageForecastInfoEntity?, _ dayInterval: Int, _ selectedHour: String) -> [String: String]? {
        
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        // 원하는 날짜 멥핑
        let todayForecast = response?.data!.list[selectedDate]!.forecasts
        
        //        let selectedHour = "\((date.today24Time.components(separatedBy: " ").map { $0 })[2])00"
        //        let selectedHour = "\(date.today24Time)"
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
                    print(key)
                    returnCategoryValues?.updateValue(key.value, forKey: key.key)
                }
            }
        }
        
        if selectedHour != "\(TMNTime)00" {
            for key in orderedByTimeCategories![TMNTime].value {
                if key.key == "TMN" {
                    print(key)
                    returnCategoryValues?.updateValue(key.value, forKey: key.key)
                }
            }
        }
        return returnCategoryValues ?? [:]
    }
    
    func getWeatherImage(_ categoryValues: [String: String]?) {
        if !categoryValues!.isEmpty {
            let rainPossibility = Int(categoryValues!["POP"]!)!
            let rainForm = Int(categoryValues!["PTY"]!)
            guard var rainfall: Int? = {
                if (categoryValues!["PCP"] == "강수없음" || categoryValues!["PCP"] == "적설없음") {
                    return 0
                }else {
                    return Int(categoryValues!["PCP"]!)
                }
            }() else { return }
            let humidity = categoryValues!["REH"]
            let skyStatus = Int(categoryValues!["SKY"]!)!
            let temp = categoryValues!["TMP"]
            let maxTemp = categoryValues!["TMX"]
            let minTemp = categoryValues!["TMN"]
            let windSpeed = categoryValues!["WSD"]
            
            var weatherImage = ""
            var message = ""
            
            switch rainPossibility {
                /// 강수 확률 있는 경우
                /// 강수 형태가 눈일수도 있기때문에 강수형태도 고려해야한다.
            case 1...:
                if rainfall! >= 40 {
                    // weatherImage -> 비오는 거
                    // rainForl 확인 -> 눈 ? 비 ?
                    // message -> 비관련
                } else {
                    // WI -> ?
                    // rainForl 확인 -> 눈 ? 비 ?
                    // message -> ?
                }
            case ...0:
                switch skyStatus {
                case 1:
                    // WI -> 맑음
                    // message -> 습도, 풍속
                    break
                case 3:
                    // WI -> 구름
                    // message -> 습도, 풍속
                    break
                case 4:
                    // WI -> 흐림
                    // message -> 습도, 풍속
                    break
                default:
                    break
                }
                break
            default:
                break
            }
            
            if rainPossibility > 0 {
                if rainfall! >= 40 {
                    // weatherImage -> 비오는 거
                    // message -> 비관련
                } else {
                    // WI -> ?
                    // message -> ?
                }
            } else {
                
            }
            print(categoryValues)
        }
    }
    
    func swipeAndReloadData(_ dayInterval: Int) -> [String: String?]? {
        
        /// 1. 현재시간 가져오기
        /// 2. 현재시간 보다 작으면 아무액션 없기.
        /// 3. 시간 배열 들고있기.
        /// [ 0700, 0900, 1200, 1500, 1800, 2100, 0000 ]
        /// 
        print("Swipe:@@@@@@@@", self.villageForeCastInfoEntityRelay.value!)
        return [:]
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
    
    public func toSensoryTempView() {
        let vc = HomeSensoryTempViewController(HomeSensoryTempViewModel())
        presentViewControllerWithAnimationRelay.accept(vc)
    }
    
    public func didTapClosetCell() {
        
    }
    
    
}

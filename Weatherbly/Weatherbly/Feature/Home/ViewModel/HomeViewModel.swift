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
//    let villageForeCastInfoEntityRelay  = BehaviorRelay<[String: String?]?>(value: [:])
    let villageForeCastInfoEntityRelay  = BehaviorRelay<VillageForecastInfoEntity?>(value: nil)
    let mappedCategoryDicRelay = BehaviorRelay<[String: String?]?>(value: [:])
    let chageDateTimeRelay = BehaviorRelay<[String]?>(value: nil)
    private let getVilageDataSource = GetVilageForcastInfoDataSource()
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func getVillageForecastInfo() {
        
        getVilageDataSource.getVilageForcast()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    // 오늘, 지금 시간,
//                    let todayInfo = self?.bindingDateWeather(response, 0)
//                    self?.villageForeCastInfoEntityRelay.accept(todayInfo)

                    
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
                    
//                    print(response.data!)
                    self?.villageForeCastInfoEntityRelay.accept(response)
//                    print(123)
                    
                    
                case .failure(let error):
                    print("viewModel Error : ", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    
    func bindingDateWeather(_ response: VillageForecastInfoEntity?, _ dayInterval: Int) -> [String: String?] {
        
        let date = Date()
        let selectedDate = date.dayAfter(dayInterval)
        // 원하는 날짜 멥핑
        let todayForecast = response?.data!.list[selectedDate]!.forecasts
        
        let selectedHour = "\((date.todayTime.components(separatedBy: " ").map { $0 })[3])00"
        let TMXTime = 15
        let TMNTime = 6
        
        
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        todayForecast?.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let timeSortedCategoryValue: [Dictionary<String, [String : String]>.Element]? = timeToCategoryValue.sorted { $0.key < $1.key }
//        print(timeSortedCategoryValue)
        
        // 현재시간인 카테고리 가져오기
        var categoriesAndValues: [String: String] = [:]
        for key in timeSortedCategoryValue! {
            if key.key == selectedHour {
                // 카테고리 맵핑해서 저장하기
                categoriesAndValues = key.value
                break
            }
        }
        
        // TODO: - 현재시간과 비교해서 15 또는 06이면 따로 가져오는 함수 실행하지 않는다.
        
        
        // TODO: - TMN,TMX 값 추가하기
        guard !timeSortedCategoryValue!.isEmpty else {
            return [:]
        }

        for key in timeSortedCategoryValue![TMXTime].value {
            if key.key == "TMX" {
                print(key)
                categoriesAndValues.updateValue(key.value, forKey: key.key)
            }
        }
        for key in timeSortedCategoryValue![TMNTime].value {
            if key.key == "TMN" {
                print(key)
                categoriesAndValues.updateValue(key.value, forKey: key.key)
            }
        }
        
        print(categoriesAndValues)

        
        
        
        return categoriesAndValues
    }
    
    func getMaxTMP(_ time: String, _ forecasts: [VilageFcstList]?) {
        
    }
    func getMinTMP() {
        
    }
    
    func swipeAndReloadData(_ dayInterval: Int) -> [String: String?]? {
     
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
    
    public func didTapClosetCell() {
        
    }
    
    
}

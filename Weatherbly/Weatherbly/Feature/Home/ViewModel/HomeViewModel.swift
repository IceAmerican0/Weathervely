//
//  HomeViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import Foundation
import RxSwift
import RxCocoa

public enum HomeViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    func toSettingView()
    func toDailyForecastView()
    func toTenDaysForecastView()
    func didTapClosetCell()
    func getVillageForecastInfo()
    var viewAction: PublishRelay<HomeViewAction> { get }
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    
    public var viewAction: RxRelay.PublishRelay<HomeViewAction>
    let villageForeCastInfoEntityRelay  = BehaviorRelay<[String: String?]?>(value: [:])
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
                    let todayInfo = self?.bindingDateWeather(response, 0)
                    self?.villageForeCastInfoEntityRelay.accept(todayInfo)
                    
                    
                case .failure(let error):
                    print("viewModel Error : ", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    
    func bindingDateWeather(_ response: VillageForecastInfoEntity, _ timeInterval: Int) -> [String: String?] {
        
        let date = Date()
        let selectedDate = date.dayAfter(timeInterval)
        let todayForecast = response.data!.list[selectedDate]!.forecasts
        
        let selectedHour = "\((date.todayTime.components(separatedBy: " ").map { $0 })[3])00"
        
        
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        todayForecast.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
        
        // 시간 오름차순
        let timeSortedCategoryValue = timeToCategoryValue.sorted { $0.key < $1.key }
//        print(timeSortedCategoryValue)
        
        // 현재시간인 카테고리 가져오기
        var categoriesAndValues: [String: String?] = [:]
        for key in timeSortedCategoryValue {
            if key.key == selectedHour {
                // 카테고리 맵핑해서 저장하기
                categoriesAndValues = key.value
                break
            }
        }
        
        return categoriesAndValues
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

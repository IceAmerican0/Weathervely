//
//  TestViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/25.
//

import Foundation
import RxCocoa
import RxSwift

public enum TestViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol TestViewModelLogic: ViewModelBusinessLogic {
    func testRequest(_ nickname: String)
    var viewAction: PublishRelay<TestViewAction> { get }
}


class TestViewModel: RxBaseViewModel, TestViewModelLogic {
    
    var viewAction: RxRelay.PublishRelay<TestViewAction>
    let loginDataSource = LoginDataSource()
    let getVilageDataSource = GetVilageForcastInfoDataSource()
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    func testRequest(_ nickname: String) {
        
        //        loginDataSource.login(nickname)
        //            .subscribe(onNext: { result in
        //                switch result {
        //                case .success(let response):
        //                    print(response)
        //                case .failure(let error):
        //
        //                    print("viewModel Error: ", error.asAFError)
        //                }
        //            })
        //            .disposed(by: bag)
        
        
        getVilageDataSource.getVilageForcast()
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    
                    let date = Date()
                    let today = date.dayAfter(1)
                    print(today)
                    self.bindingDateWeather(response, 0)
                    
//                    print("viewModel response : ", response.data!.list[today]!)
                case .failure(let error):
                    print("viewModel Error : ", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    
    func bindingDateWeather(_ response: GetVilageForcastInfoEntity, _ timeInterval: Int) {
        
        let date = Date()
        let selectedDate = date.dayAfter(timeInterval)
        let todayForecast = response.data!.list[selectedDate]!.forecasts
        
        let currentHour = "\((date.todayTime.components(separatedBy: " ").map { $0 })[3])00"
        
        
        var timeToCategoryValue: [String: [String: String]] = [:]
        // 시간을 key 값으로 재정렬
        todayForecast.forEach { forecast in
            if timeToCategoryValue[forecast.fcstTime] == nil {
                timeToCategoryValue[forecast.fcstTime] = [:]
            }
            timeToCategoryValue[forecast.fcstTime]?[forecast.category] = forecast.fcstValue
        }
//        let allowedCategories: Set<String> = ["POP", "PTY", "PCP", "SKY", "TMP", "TMX", "TMN", "WSD", "REH"]
        
        
        // 시간 오름차순
        let timeSortedCategoryValue = timeToCategoryValue.sorted { $0.key < $1.key }
//        print(timeSortedCategoryValue)
        
        // 현재시간인 카테고리 가져오기
        for key in timeSortedCategoryValue {
            if key.key == currentHour {
                // 카테고리 맵핑해서 저장하기
                let a = key.value
                print(a["TMP"]!)
                
                break
            }
        }
    }
    
    
}

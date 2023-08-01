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
                    
                    
                    print("viewModel response : ", response.data!.list[today]!)
                case .failure(let error):
                    print("viewModel Error : ", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
}

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
//    let testDataSource = LoginDataSource()
    let testDataSource = GetVilageForcastInfoDataSource()
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    func testRequest(_ nickname: String) {
        
        testDataSource.getCloset()
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    
                    print("viewModel Error: ", error.asAFError)
                }
            })
            .disposed(by: bag)
        
    }
}

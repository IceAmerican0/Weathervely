//
//  OnBoardViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit
import RxSwift
import RxCocoa

public enum OnBoardViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol OnBoardViewModelLogic: ViewModelBusinessLogic {
    func login(_ nickname: String)
    var viewAction: PublishRelay<OnBoardViewAction> { get }
}

class OnBoardViewModel: RxBaseViewModel, OnBoardViewModelLogic {
    
    var viewAction: RxRelay.PublishRelay<OnBoardViewAction>
    
    
    let loginDataSource = LoginDataSource()
    
    
    override init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func toNicknameView() {
        let vc = NicknameViewController(NicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func login(_ nickname: String ) {
        loginDataSource.login(nickname)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
}

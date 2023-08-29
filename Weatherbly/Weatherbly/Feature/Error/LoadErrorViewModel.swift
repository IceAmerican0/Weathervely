//
//  LoadErrorViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/27.
//

import UIKit
import RxSwift

public protocol LoadErrorViewModelLogic: ViewModelBusinessLogic {
    func getToken()
}

final public class LoadErrorViewModel: RxBaseViewModel, LoadErrorViewModelLogic {
    public func getToken() {
        let loginDataSource = AuthDataSource()
        loginDataSource.getToken()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    let data = response.data
                    userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)

                    if let address = data.address {
                        userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                        if data.setTemperature == true {
                            self?.navigationPushViewControllerRelay.accept(HomeViewController(HomeViewModel()))
                        } else {
                            self?.navigationPushViewControllerRelay.accept(DateTimePickViewController(DateTimePickViewModel()))
                        }
                    } else {
                        self?.navigationPushViewControllerRelay.accept(SettingRegionViewController(SettingRegionViewModel(.onboard)))
                    }
                case .failure(let err):
                    switch err {
                    case .noInternetError:
                        self?.alertMessageRelay.accept(.init(title: "인터넷 연결을 확인해주세요",
                                                             alertType: .Info))
                    default:
                        self?.navigationPushViewControllerRelay.accept(OnBoardViewController(OnBoardViewModel()))
                    }
                }
            })
            .disposed(by: bag)
    }
}

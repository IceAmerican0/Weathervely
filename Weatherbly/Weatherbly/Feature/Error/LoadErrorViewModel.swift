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
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success(let response):
                        let data = response.data
                        userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)

                        if let address = data.address {
                            userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                            if data.setTemperature == true {
                                owner.navigationPushViewControllerRelay.accept(HomeViewController(HomeViewModel()))
                            } else {
                                owner.navigationPushViewControllerRelay.accept(DateTimePickViewController(DateTimePickViewModel()))
                            }
                        } else {
                            owner.navigationPushViewControllerRelay.accept(SettingRegionViewController(SettingRegionViewModel(.onboard)))
                        }
                    case .failure(let err):
                        switch err {
                        case .noInternetError:
                            owner.alertMessageRelay.accept(.init(title: "인터넷 연결을 확인해주세요",
                                                                 alertType: .Info))
                        default:
                            owner.navigationPushViewControllerRelay.accept(OnBoardViewController(OnBoardViewModel()))
                        }
                    }
            })
            .disposed(by: bag)
    }
}

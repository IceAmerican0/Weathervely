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
                onNext: { owner, response in
                    let data = response.data
                    userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)
                    
                    if let address = data.address {
                        userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                        if data.setTemperature == true {
                            owner.navigationPushViewControllerRelay.accept(HomeTabBarController())
                        } else {
                            owner.navigationPushViewControllerRelay.accept(DateTimePickViewController(DateTimePickViewModel()))
                        }
                    } else {
                        owner.navigationPushViewControllerRelay.accept(SettingRegionViewController(SettingRegionViewModel(.onboard)))
                    }
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .toast))
            })
            .disposed(by: bag)
    }
}

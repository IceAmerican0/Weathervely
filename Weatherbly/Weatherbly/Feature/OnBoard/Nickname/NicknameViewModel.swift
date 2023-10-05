//
//  NicknameViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/19.
//

import Foundation
import RxSwift
import RxRelay

public protocol NicknameViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ text: String)
    func toSettingRegionView()
}

final class NicknameViewModel: RxBaseViewModel, NicknameViewModelLogic {
    func didTapConfirmButton(_ text: String) {
        let uuid = UUID().uuidString
        let dataSource = AuthDataSource()
        dataSource.setNickname(text, uuid)
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success:
                        owner.toSettingRegionView()
                        userDefault.set(text, forKey: UserDefaultKey.nickname.rawValue)
                        KeychainManager.shared.saveUUID(uuid)
                    case .failure(let err):
                        switch err {
                        case .noInternetError:
                            owner.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
                        default:
                            guard let errorString = err.errorDescription else { return }
                            owner.alertMessageRelay.accept(.init(title: errorString,
                                                                alertType: .Error))
                        }
                    }
            })
            .disposed(by: bag)
    }
    
    func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
        navigationPushViewControllerRelay.accept(vc)
    }
}

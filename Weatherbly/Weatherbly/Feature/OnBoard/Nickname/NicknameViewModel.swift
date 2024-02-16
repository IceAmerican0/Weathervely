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
                onNext: { owner, _ in
                    owner.toSettingRegionView()
                    userDefault.set(text, forKey: UserDefaultKey.nickname.rawValue)
                    KeychainManager.shared.saveUUID(uuid)
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
        navigationPushViewControllerRelay.accept(vc)
    }
}

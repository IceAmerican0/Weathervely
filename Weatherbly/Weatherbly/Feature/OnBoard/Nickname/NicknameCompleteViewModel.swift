//
//  NicknameCompleteViewModel.swift
//  Weatherbly
//
//  Created by Khai on 2/22/24.
//

import UIKit

public protocol NicknameCompleteViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton()
    func didTapRefuseButton()
    func toSettingRegionView()
    
    var nickname: String { get }
}

public final class NicknameCompleteViewModel: RxBaseViewModel, NicknameCompleteViewModelLogic {
    public var nickname: String
    
    public init(nickname: String) {
        self.nickname = nickname
    }
    
    public func didTapRefuseButton() {
        navigationPopViewControllerRelay.accept(Void())
    }
    
    public func didTapConfirmButton() {
        let uuid = UUID().uuidString
        let dataSource = AuthDataSource()
        dataSource.setNickname(nickname, uuid)
            .subscribe(
                with: self,
                onNext: { owner, nickname in
                    owner.toSettingRegionView()
                    userDefault.set(nickname, forKey: UserDefaultKey.nickname.rawValue)
                    KeychainManager.shared.saveUUID(uuid)
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    public func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
        navigationPushViewControllerRelay.accept(vc)
    }
}

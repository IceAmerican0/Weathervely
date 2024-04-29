//
//  NicknameCompleteViewModel.swift
//  Weatherbly
//
//  Created by Khai on 2/22/24.
//

import UIKit

public protocol NicknameCompleteViewModelLogic: ViewModelBusinessLogic {
    func didTapRefuseButton()
    func didTapConfirmButton()
    
    var nickname: String { get }
}

public final class NicknameCompleteViewModel: RxBaseViewModel, NicknameCompleteViewModelLogic {
    public var nickname: String
    
    public init(nickname: String) {
        self.nickname = nickname
    }
    
    /// 아니오 버튼
    public func didTapRefuseButton() {
        navigationPopViewControllerRelay.accept(Void())
    }
    
    /// 네 버튼
    public func didTapConfirmButton() {
        let uuid = UUID().uuidString
        let dataSource = AuthDataSource()
        dataSource.setNickname(nickname, uuid)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toSettingRegionView()
                    userDefault.set(owner.nickname, forKey: UserDefaultKey.nickname.rawValue)
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
    
    /// 동네설정뷰
    private func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
        navigationSetRootPushViewControllerRelay.accept(vc)
    }
}

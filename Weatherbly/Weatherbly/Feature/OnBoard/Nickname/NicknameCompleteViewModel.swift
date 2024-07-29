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
        UserDefaultManager.shared.isOnBoard ? setNickname() : editNickname()
    }
    
    private func generateSafeUUID() -> String {
        // 최대 3번 시도
        for _ in 0..<3 {
            let uuid = UUID().uuidString
            if uuid.count != 0 {
                return uuid
            }
        }
        
        return "tempID-" + Date().microCurrent
    }
    
    /// 닉네임 설정(온보딩)
    private func setNickname() {
        let uuid = generateSafeUUID()
        let dataSource: AuthDataSourceProtocol = AuthDataSource()
        dataSource.setNickname(nickname, uuid)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toSettingRegionView()
                    userDefault.set(owner.nickname, forKey: UserDefaultKey.nickname.rawValue)
                    userDefault.set(uuid, forKey: UserDefaultKey.uuid.rawValue)
                    KeychainManager.shared.saveUUID(uuid)
                },
                onError: { owner, error in
                    debugPrint(error.localizedDescription)
                    owner.alertState.accept(
                        .init(
                            title: "닉네임을 다시 설정해주세요",
                            alertType: .popup,
                            closeAction: {
                                owner.didTapRefuseButton()
                            }
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 닉네임 수정
    private func editNickname() {
        let userInfo = UserInfoRequest(nickname: nickname)
        let dataSource: UserDataSourceProtocol = UserDataSource()
        dataSource.fetchUserInfo(userInfo)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toSettingView()
                    userDefault.set(owner.nickname, forKey: UserDefaultKey.nickname.rawValue)
                },
                onError: { owner, error in
                    debugPrint(error.localizedDescription)
                    owner.alertState.accept(
                        .init(
                            title: "닉네임을 다시 설정해주세요",
                            alertType: .popup,
                            closeAction: {
                                owner.didTapRefuseButton()
                            }
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 마이페이지
    private func toSettingView() {
        navigationPushToPreviousViewControllerRelay.accept([])
    }
    
    /// 동네설정뷰
    private func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
        navigationSetRootPushViewControllerRelay.accept(vc)
    }
}

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
        UserDefaultManager.shared.isOnBoard ? generateSafeUUID() : editNickname()
    }
    
    private func generateSafeUUID() {
        let uuid: String? = UUID().uuidString
        let tempID: String = "tempID-" + Date().microCurrent
        
        if uuid != nil && uuid?.isEmpty == false {
            userDefault.set(uuid ?? tempID, forKey: UserDefaultKey.uuid.rawValue)
            KeychainManager.shared.saveUUID(uuid ?? tempID)
            setNickname()
        } else {
            userDefault.set(tempID, forKey: UserDefaultKey.uuid.rawValue)
            KeychainManager.shared.saveUUID(tempID)
            setNickname()
        }
    }
    
    /// 닉네임 설정(온보딩)
    private func setNickname() {
        let dataSource: AuthDataSourceProtocol = AuthDataSource()
        dataSource.setNickname(nickname)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toSettingRegionView()
                    userDefault.set(owner.nickname, forKey: UserDefaultKey.nickname.rawValue)
                },
                onError: { owner, error in
                    debugPrint(error.localizedDescription)
                    
                    if error.localizedDescription.contains("유효성") {
                        KeychainManager.shared.deleteUUID()
                        
                        let tempID: String = "tempID-" + Date().microCurrent
                        userDefault.set(tempID, forKey: UserDefaultKey.uuid.rawValue)
                        KeychainManager.shared.saveUUID(tempID)
                        
                        owner.setNickname()
                    } else {
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

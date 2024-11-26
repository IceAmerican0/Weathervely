//
//  LaunchProcess.swift
//  Weathervely
//
//  Created by Khai on 11/20/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit
import UIUtil
import WVAlert
import WVNetwork
import RxSwift

public protocol LaunchProtocol {
    func getToken()
}

public class LaunchProcess: LaunchProtocol {
    
    var coordinator: RootCoordinator
    var bag = DisposeBag()
    
    public init(window: UIWindow?) {
        self.coordinator = RootCoordinator(window: window, navigationController: UINavigationController())
    }
    
    /// 로그인 토큰(버전 확인 및 업데이트 판별 후 >> 화면분기)
    public func getToken() {
        Task {
            let loginDataSource: AuthDataSourceProtocol = AuthDataSource()
            loginDataSource.getToken(await UserNotificationManager.shared.configurePushState())
                .subscribe(
                    with: self,
                    onNext: { owner, response in
                        owner.configureVersion(userInfo: response.data)
                    },
                    onError: { owner, error in
                        owner.configureErrorState(message: error.localizedDescription)
                    }
                ).disposed(by: bag)
        }
    }
    
    func configureVersion(userInfo: AuthData) {
        let compareResult = Constants.bundleShortVersion.compareVersion(with: userInfo.latestVersion)
        if case .orderedAscending = compareResult {
            showAlert(
                title: "새로운 버전이 출시됐어요!\n앱스토어에서 업데이트해주세요",
                action: { self.sendToAppStore() }
            )
            return
        }
        
        if Constants.bundleShortVersion != userInfo.version {
            let userDataSource: UserDataSourceProtocol = UserDataSource()
            userDataSource.fetchUserVersion()
                .subscribe(
                    with: self,
                    onError: { _, error in
                        debuggerPrint("버전 업데이트 실패: \(error)")
                    }
                ).disposed(by: bag)
        }
        
        loginProcess(userInfo: userInfo)
    }
    
    func loginProcess(userInfo: AuthData) {
        userDefault.set(userInfo.user.nickname, forKey: UserDefaultKey.nickname.rawValue)
        
        if let address = userInfo.address {
            userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
        }
        
        coordinator.start()
    }
    
    /// 토큰 에러 분기
    func configureErrorState(message: String) {
        switch message {
        case "유저가 존재하지 않습니다.",
             "기기고유번호":
            KeychainManager.shared.deleteUUID()
            userDefault.removeObject(forKey: UserDefaultKey.uuid.rawValue)
            coordinator.start()
        case "FCM 기기 토큰",
             "토큰이 만료 되었습니다.":
            getToken()
        default:
            showAlert(title: message, action: {
                if message.contains("도메인") {
                    self.sendToAppStore()
                } else {
                    self.getToken()
                }
            })
        }
    }
    
    func showAlert(title: String, action: @escaping () -> Void) {
        let state: AlertViewState = .init(
            title: title,
            closeAction: action
        )
        
        AlertManager.shared.present(state: state)
    }
    
    /// 앱스토어 열기 후 앱 종료
    func sendToAppStore() {
        guard let appStoreLink = URL(string: Constants.appStoreLink) else { return }
        UIApplication.shared.open(appStoreLink) { _ in
            UIApplication.shared.close()
        }
    }
}

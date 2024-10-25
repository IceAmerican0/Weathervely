//
//  SceneDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import DesignSystem
import Network
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var bag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white

        getToken()
    }
    
    func setWindow(_ vc: UIViewController) {
        let rootVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
    /// 로그인 토큰(버전 확인 및 업데이트 판별 후 >> 화면분기)
    func getToken() {
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
                        debugPrint("버전 업데이트 실패: \(error)")
                    }
                ).disposed(by: bag)
        }
        
        loginProcess(userInfo: userInfo)
    }
    
    func loginProcess(userInfo: AuthData) {
        userDefault.set(userInfo.user.nickname, forKey: UserDefaultKey.nickname.rawValue)
        
        if let address = userInfo.address {
            userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
            window?.rootViewController = HomeTabBarController()
            window?.makeKeyAndVisible()
        } else {
            setWindow(SettingRegionViewController(SettingRegionViewModel(.onboard)))
        }
    }
    
    /// 토큰 에러 분기
    func configureErrorState(message: String) {
        switch message {
        case "유저가 존재하지 않습니다.",
             "기기고유번호":
            KeychainManager.shared.deleteUUID()
            userDefault.removeObject(forKey: UserDefaultKey.uuid.rawValue)
            setWindow(OnBoardViewController(OnBoardViewModel()))
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
            alertType: .popup,
            closeAction: action
        )
        
        AlertView(state: state).show(on: self.window ?? UIWindow())
        window?.makeKeyAndVisible()
    }
    
    /// 앱스토어 열기 후 앱 종료
    func sendToAppStore() {
        guard let appStoreLink = URL(string: Constants.appStoreLink) else { return }
        UIApplication.shared.open(appStoreLink) { _ in
            UIApplication.shared.close()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

//
//  SceneDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var bag = DisposeBag()
    
    let userDataSource: UserDataSourceProtocol = UserDataSource()

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
    
    /// 로그인 토큰
    func getToken() {
        Task {
            let loginDataSource: AuthDataSourceProtocol = AuthDataSource()
            loginDataSource.getToken(await UserNotificationManager.shared.configurePushState())
                .subscribe(
                    with: self,
                    onNext: { owner, response in
                        let data = response.data
                        userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)
                        
                        if let address = data.address {
                            userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                            owner.window?.rootViewController = HomeTabBarController()
                            owner.window?.makeKeyAndVisible()
                        } else {
                            owner.setWindow(SettingRegionViewController(SettingRegionViewModel(.onboard)))
                        }
                    },
                    onError: { owner, error in
                        owner.configureErrorState(message: error.localizedDescription)
                    }
                ).disposed(by: bag)
        }
    }
    
    func getUserInfo() {
        userDataSource.getUserInfo()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let id = response.id else { return }
                    owner.versionUpdate(id: id)
                },
                onError: { owner, error in
                    owner.showAlert(
                        title: "서버가 불안정해요\n앱을 재실행 해주세요",
                        action: { UIApplication.shared.close() }
                    )
                }
            ).disposed(by: bag)
    }
    
    func versionUpdate(id: Int) {
        userDataSource.fetchUserVersion(id)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.getToken()
                },
                onError: { owner, error in
                    owner.configureErrorState(message: error.localizedDescription)
                }
            ).disposed(by: bag)
    }
    
    /// 토큰 에러 분기
    func configureErrorState(message: String) {
        if message.contains("유저의 version") {
            getUserInfo()
            return
        }
        
        if message.contains("업데이트가 필요") {
            showAlert(
                title: "새로운 버전이 출시됐어요!\n앱스토어에서 업데이트해주세요",
                action: { self.sendToAppStore() }
            )
            return
        }
        
        if message.contains("FCM") || message.contains("토큰이 만료") {
            getToken()
            return
        }
        
        if message.contains("유저가 존재") {
            setWindow(OnBoardViewController(OnBoardViewModel()))
        } else {
            showAlert(title: message, action: {
                if message.contains("도메인") {
                    self.sendToAppStore()
                    return
                }
                self.getToken()
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
        UIApplication.shared.open(appStoreLink)
        UIApplication.shared.close()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

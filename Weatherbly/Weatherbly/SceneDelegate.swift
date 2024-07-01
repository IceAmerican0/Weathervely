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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

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
            loginDataSource.getToken(await configurePushState())
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
                        if error.localizedDescription == "FCM 기기 토큰" {
                            owner.getToken()
                        } else {
                            owner.setWindow(OnBoardViewController(OnBoardViewModel()))
                        }
                    }
                ).disposed(by: bag)
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

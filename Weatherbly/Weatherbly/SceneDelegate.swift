//
//  SceneDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        intro()
    }
    
    func intro() {
        var vc: UIViewController {
            if UserDefaultManager.shared.isOnBoard {
                if let nickname = userDefault.object(forKey: UserDefaultKey.nickname.rawValue) {
                    return SettingRegionViewController(SettingRegionViewModel())
                } else {
                    return OnBoardViewController(OnBoardViewModel())
                }
            } else {
                return HomeViewController(HomeViewModel())
            }
        }
        
        let rootVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}


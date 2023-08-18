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
    var vc: UIViewController?
    var bag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        intro()
    }
    
    func intro() {
//        userDefault.set("test1111", forKey: UserDefaultKey.nickname.rawValue) // TODO: 지우기
//        userDefault.removeObject(forKey: UserDefaultKey.isOnboard.rawValue) // TODO: 지우기
        if UserDefaultManager.shared.nickname == "알수없음" {
            vc = OnBoardViewController(OnBoardViewModel())
            setWindow()
        } else {
            if UserDefaultManager.shared.isOnBoard == true {
                vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
                setWindow()
            } else {
                getToken()
            }
        }
    }
    
    func setWindow() {
        let rootVC = UINavigationController(rootViewController: vc ?? HomeViewController(HomeViewModel()))
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func getToken() {
        let loginDataSource = AuthDataSource()
        loginDataSource.getToken(UserDefaultManager.shared.nickname)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    self.vc = HomeViewController(HomeViewModel())
                    self.setWindow()
                case .failure(let err): // TODO: 토큰 실패시 에러 처리
                    guard let errString = err.errorDescription else { return }
//                    self.alertMessageRelay.accept(.init(title: errString, alertType: .Error))
                }
            })
            .disposed(by: bag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}


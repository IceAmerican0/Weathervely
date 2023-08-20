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
        if UserDefaultManager.shared.nickname.isEmpty == true {
            vc = OnBoardViewController(OnBoardViewModel())
            setWindow()
        } else {
            getToken()
        }
    }
    
    func setWindow() {
        guard let vc = vc else { return }
        let rootVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func getToken() {
        let loginDataSource = AuthDataSource()
        loginDataSource.getToken(UserDefaultManager.shared.nickname)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    if UserDefaultManager.shared.isOnBoard == true {
                        self?.vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
                    } else {
                        self?.vc = HomeViewController(HomeViewModel())
                    }
                    self?.setWindow()
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


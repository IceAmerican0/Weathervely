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

        getToken()
    }
    
    func setWindow() {
        guard let vc = vc else { return }
        let rootVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func getToken() {
        let loginDataSource = AuthDataSource()
        loginDataSource.getToken()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    let data = response.data
                    userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)

                    if let address = data.address {
                        userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                        if data.setTemperature == true {
                            self?.vc = HomeViewController(HomeViewModel())
                        } else {
                            self?.vc = DateTimePickViewController(DateTimePickViewModel())
                        }
                    } else {
                        self?.vc = SettingRegionViewController(SettingRegionViewModel(.onboard))
                    }
                    self?.setWindow()
                case .failure(let err):
                    switch err {
                    case .noInternetError:
                        self?.vc = LoadErrorViewController(LoadErrorViewModel())
                        self?.setWindow()
                    default:
                        self?.vc = OnBoardViewController(OnBoardViewModel())
                        self?.setWindow()
                    }
                }
            })
            .disposed(by: bag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        getToken()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}


//
//  SceneDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit
import RxSwift
import Firebase
import FirebaseRemoteConfig

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var bag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        /// Firebase
        FirebaseApp.configure()

        checkForceUpdate()
    }
    
    func setWindow(_ vc: UIViewController) {
        let rootVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
    
    func checkForceUpdate() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch() { status, _ -> Void in
            if status == .success {
                remoteConfig.activate() { _, error in
                    let forceUpdate = remoteConfig["force_update"].boolValue
                    let updateVersion = remoteConfig["minimum_ver"].stringValue ?? "1.0.0"
                    
                    if forceUpdate == true {
                        let clientVersion = Constants.bundleShortVersion.versionToInt()
                        if clientVersion < updateVersion.versionToInt() {
                            DispatchQueue.main.async {
                                self.setWindow(ForceUpdateViewController(EmptyViewModel()))
                            }
                        } else {
                            self.getToken()
                        }
                    } else {
                        self.getToken()
                    }
                }
            } else {
                self.getToken()
            }
        }
    }
    
    func getToken() {
        let loginDataSource = AuthDataSource()
        loginDataSource.getToken()
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success(let response):
                        let data = response.data
                        userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)

                        if let address = data.address {
                            userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                            if data.setTemperature == true {
                                owner.setWindow(HomeViewController(HomeViewModel()))
                            } else {
                                owner.setWindow(DateTimePickViewController(DateTimePickViewModel()))
                            }
                        } else {
                            owner.setWindow(SettingRegionViewController(SettingRegionViewModel(.onboard)))
                        }
                    case .failure(let err):
                        switch err {
                        case .noInternetError:
                            owner.setWindow(LoadErrorViewController(LoadErrorViewModel()))
                        default:
                            owner.setWindow(OnBoardViewController(OnBoardViewModel()))
                        }
                    }
            })
            .disposed(by: bag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        checkForceUpdate()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}


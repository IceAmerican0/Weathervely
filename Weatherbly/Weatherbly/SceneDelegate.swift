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
        
        let rootVC = UINavigationController(rootViewController: CSButtonTestsViewController(EmptyViewModel()))
        
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        /// Firebase
//        FirebaseApp.configure()
//        registerRemoteNotification()
//        checkToken()
//
//        checkForceUpdate()
    }
    
    func setWindow(_ vc: UIViewController) {
        let rootVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = vc == HomeTabBarController() ? vc : rootVC
        self.window?.makeKeyAndVisible()
    }
    
    /// 강제 업데이트 여부
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
    
    /// 로그인 토큰
    func getToken() {
        let loginDataSource = AuthDataSource()
        loginDataSource.getToken()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let data = response.data
                    userDefault.set(data.user.nickname, forKey: UserDefaultKey.nickname.rawValue)
                    
                    if let address = data.address {
                        userDefault.set(address.dong, forKey: UserDefaultKey.dong.rawValue)
                        if data.setTemperature == true {
                            owner.setWindow(HomeTabBarController())
                        } else {
                            owner.setWindow(DateTimePickViewController(DateTimePickViewModel()))
                        }
                    } else {
                        owner.setWindow(SettingRegionViewController(SettingRegionViewModel(.onboard)))
                    }
                },
                onError: { owner, _ in
                    owner.setWindow(OnBoardViewController(OnBoardViewModel()))
            })
            .disposed(by: bag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
//        checkForceUpdate()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

// MARK: FCM & APNs
extension SceneDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    /// FCM 기본 세팅
    func registerRemoteNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        
        UIApplication.shared.registerForRemoteNotifications()
        
        let messaging = Messaging.messaging()
        messaging.delegate = self
        messaging.isAutoInitEnabled = true
    }
    
    /// FCM Token 확인용
    func checkToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
    
    /// FCM Token 등록
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}


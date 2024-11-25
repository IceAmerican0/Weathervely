//
//  AppDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import WVNetwork
import UIUtil
import Foundation
import Firebase
import FirebaseRemoteConfig
import KakaoMapsSDK
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var notificationCenter = UNUserNotificationCenter.current()
    var bag = DisposeBag()
    
    private let userDataSource: UserDataSourceProtocol = UserDataSource()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        
        /// Kakao
        SDKInitializer.InitSDK(appKey: Constants.kakaoAppKeyNative)
        
        /// Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        registerRemoteNotification()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}

// MARK: FCM & APNs
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    /// https://firebase.google.com/docs/cloud-messaging/ios/client?hl=ko 참고
    /// 알림 설정
    func registerRemoteNotification() {
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, _ in
            Task { @MainActor in
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                    userDefault.set(true, forKey: UserDefaultKey.pushAgreement.rawValue)
                } else {
                    if UserDefaultManager.shared.pushAgreement {
                        userDefault.removeObject(forKey: UserDefaultKey.pushAgreement.rawValue)
                    }
                }
            }
        }
    }
    
    /// FCM Token 확인용
    /// 해당 메서드를 통해서 토큰을 저장하지 않고 언제든지 토큰에 액세스 가능
    /// token 클로저를 통하여 토큰을 직접 가져올 수 있다. 실패일 경우 nil이 아닌 오류를 내보낸다.
    func checkFCMToken() {
        Messaging.messaging().token { token, error in
            if let error {
                debuggerPrint("Error fetching FCM registration token: \(error)")
            } else if let token {
                debuggerPrint("FCM registration token: \(token)")
            }
        }
    }
    
    func deleteFCMToken() {
        Messaging.messaging().deleteToken { error in
            if let error {
                debuggerPrint("Error Deleting FCM token: \(error)")
            } else {
                self.checkFCMToken()
            }
        }
    }
    
    /// FCM 토큰 세팅
    func sendFCMToken(token: String) {
        userDataSource.fetchFCMToken(token)
            .subscribe (
                with: self,
                onNext: { owner, _ in
                    owner.setPushAgreement()
                },
                onError: { owner, error in
                    userDefault.set(false, forKey: UserDefaultKey.pushAgreement.rawValue)
                    owner.setPushAgreement()
                    debuggerPrint("FCMToken Edit Failed: \(error)")
                }
            ).disposed(by: bag)
    }
    
    /// 푸시 수신여부 설정
    func setPushAgreement() {
        userDataSource.fetchPushAgreement(UserDefaultManager.shared.pushAgreement)
            .subscribe(
                with: self,
                onError: { _, error in
                    debuggerPrint("푸시 수신 설정 실패: \(error)")
                }
            ).disposed(by: bag)
    }
    
    /// 토큰 갱신 모니터링
    /// -> 토큰 업데이트 시 알림을 받기위함
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if UserDefaultManager.shared.isServerChanged {
            userDefault.removeObject(forKey: UserDefaultKey.isServerChanged.rawValue)
            deleteFCMToken()
        }
        
        if UserDefaultManager.shared.pushToken != fcmToken {
            let token = UserDefaultKey.pushToken.rawValue
            
            if let fcmToken {
                userDefault.set(fcmToken, forKey: token)
                sendFCMToken(token: fcmToken)
            } else {
                userDefault.removeObject(forKey: token)
            }
        }
    }
    
    /// 백그라운드 알림 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name: .pushReceived, object: nil)
        completionHandler(.newData)
    }
    
    /// 알림 받을시(Foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: .pushReceived, object: nil)
        completionHandler([.banner, .sound])
    }
}


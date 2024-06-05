//
//  AppDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        
        /// Firebase
        FirebaseApp.configure()
        registerRemoteNotification()
        checkFCMToken()
        
        return true
    }
    
    /// 백그라운드 알림 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotificationDBManager.shared.saveNotiToDatabase(info: userInfo)
        completionHandler(.newData)
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
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func checkNotification() {
        Task {
            let isAuthorized = await checkAuthorization()
            if isAuthorized {
                registerRemoteNotification()
            }
        }
    }
    
    /// FCM Token 확인용
    /// 해당 메서드를 통해서 토큰을 저장하지 않고 언제든지 토큰에 액세스 가능
    /// token 클로저를 통하여 토큰을 직접 가져올 수 있다. 실패일 경우 nil이 아닌 오류를 내보낸다.
    func checkFCMToken() {
        let messaging = Messaging.messaging()
        messaging.delegate = self
        // 자동 초기화 방지
        messaging.isAutoInitEnabled = true
        
        messaging.token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
    
    /// 토큰 갱신 모니터링
    /// -> 토큰 업데이트 시 알림을 받기위함
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
    
    /// FCM Token 등록
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    /// 알림 받을시(Foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        PushNotificationDBManager.shared.saveNotiToDatabase(info: info)
        completionHandler([.banner, .sound])
    }
    
    /// 알림 선택시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        PushNotificationDBManager.shared.saveNotiToDatabase(info: info)
        completionHandler()
    }
}


//
//  UserNotificationManager.swift
//  Weatherbly
//
//  Created by Khai on 4/16/24.
//

import UserNotifications
import UIKit

public class UserNotificationManager {
    public static let shared = UserNotificationManager()
    
    /// 알림 권한 체크
    public func checkAuthorization() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        switch settings.authorizationStatus {
        case .notDetermined,
             .denied:
            return false
        case .authorized,
             .provisional,
             .ephemeral:
            return true
        @unknown default:
            return false
        }
    }

    /// 알림 권한 + 수신여부 체크
    public func configurePushState() async -> Bool {
        if await checkAuthorization() && UserDefaultManager.shared.pushAgreement {
            return true
        } else {
            return false
        }
    }

    /// 알림 설정창 이동
    public func toPushSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url) { success in
                guard success else { return }
                NotificationCenter.default.addObserver(
                    forName: UIApplication.willEnterForegroundNotification,
                    object: nil,
                    queue: nil
                ) { _ in
                    UNUserNotificationCenter.current().getNotificationSettings { setting in
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .returnFromSetting, object: setting)
                        }
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let pushReceived = Notification.Name("pushReceived")
    static let returnFromSetting = Notification.Name("returnFromSetting")
}

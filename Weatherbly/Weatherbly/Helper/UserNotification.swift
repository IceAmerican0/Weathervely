//
//  UserNotification.swift
//  Weatherbly
//
//  Created by Khai on 4/16/24.
//

import UserNotifications
import UIKit

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
                    
                }
            }
        }
    }
}

//
//  UserNotification.swift
//  Weatherbly
//
//  Created by Khai on 4/16/24.
//

import UserNotifications
import UIKit

@discardableResult
public func checkAuthorization() -> Bool {
    var didAuthorized = false
    
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .notDetermined,
             .denied:
            didAuthorized = false
        case .authorized,
             .provisional,
             .ephemeral:
            didAuthorized = true
        @unknown default:
            didAuthorized = false
        }
    }
    
    return didAuthorized
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

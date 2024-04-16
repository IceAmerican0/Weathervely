//
//  UserNotification.swift
//  Weatherbly
//
//  Created by Khai on 4/16/24.
//

import UserNotifications

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

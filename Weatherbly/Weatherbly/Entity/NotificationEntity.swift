//
//  NotificationEntity.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import Foundation

public struct NotificationEntity: Codable {
    let status: Int
    let data: NotificationData
}

public struct NotificationData: Codable {
//    let list: [NotificationInfo]
}

public struct NotificationInfo {
    let title: String
    let comment: String
    let receivedTime: String
}

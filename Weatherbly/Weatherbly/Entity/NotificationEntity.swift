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
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct NotificationData: Codable {
    let list: [NotificationInfo]
    
    enum CodingKeys: String, CodingKey {
        case list
    }
}

public struct NotificationInfo: Codable {
    let title: String
    let comment: String
    let receivedTime: String
    
    enum CodingKeys: String, CodingKey {
        case title, comment, receivedTime
    }
}

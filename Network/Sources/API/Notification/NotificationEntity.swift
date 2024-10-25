//
//  NotificationEntity.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import Foundation

public struct NotificationEntity: Codable {
    let id: Int
    let title: String
    let content: String
    let status: String
    let type: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, status, type
        case date = "created_at"
    }
}

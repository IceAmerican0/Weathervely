//
//  NotificationEntity.swift
//  Weatherbly
//
//  Created by Khai on 2/1/24.
//

import Foundation

public struct NotificationEntity: Codable {
    public let id: Int
    public let title: String
    public let content: String
    public let status: String
    public let type: String
    public let date: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, status, type
        case date = "created_at"
    }
}

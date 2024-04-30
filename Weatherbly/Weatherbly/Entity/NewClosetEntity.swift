//
//  NewClosetEntity.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Foundation

public struct NewClosetEntity: Codable {
    let status: Int
    let data: NewClosetData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct NewClosetData: Codable {
    let counts: Int
    let closets: [NewClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case counts, closets
    }
}

public struct NewClosetInfo: Codable {
    let closetId: Int
    let closetName: String
    let closetImageUrl: String
    let closetStatus: String
    
    enum CodingKeys: String, CodingKey {
        case closetId, closetName, closetImageUrl, closetStatus
    }
}

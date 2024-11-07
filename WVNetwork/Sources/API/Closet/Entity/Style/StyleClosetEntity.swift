//
//  StyleClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/18/24.
//

import Foundation

public struct StyleClosetEntity: Codable {
    let status: Int
    public let data: StyleClosetData
}

public struct StyleClosetData: Codable {
    public let counts: Int
    public let closets: [StyleClosetInfo]
}

public struct StyleClosetInfo: Codable {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let closetStatus: String
//    let shopName: String

    enum CodingKeys: String, CodingKey {
        case id = "closetId"
        case name = "closetName"
        case imageUrl = "closetImageUrl"
        case closetStatus
//        case shopName = "closetSiteName"
        
    }
}

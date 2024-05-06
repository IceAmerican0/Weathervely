//
//  StyleClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/18/24.
//

import Foundation

struct StyleClosetEntity: Codable {
    let status: Int
    let data: StyleClosetData
}

struct StyleClosetData: Codable {
    let counts: Int
    let closets: [StyleClosetInfo]
}

struct StyleClosetInfo: Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let closetStatus: String
//    let shopName: String

    enum CodingKeys: String, CodingKey {
        case id = "closetId"
        case name = "closetName"
        case imageUrl = "closetImageUrl"
        case closetStatus
//        case shopName = "closetSiteName"
        
    }
}

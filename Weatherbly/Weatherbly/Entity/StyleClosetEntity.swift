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
    let list: [StyleClosetDataList]
}

struct StyleClosetDataList: Codable {
    let counts: Int
    let closets: [StyleClosets]
}

struct StyleClosets: Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let saleStatus: String
    let code: String
    let style: [StyleInfo]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
        case saleStatus = "status"
        case code, style
    }
}

struct StyleInfo: Codable {
    let styleID: Int
    let name: String
}

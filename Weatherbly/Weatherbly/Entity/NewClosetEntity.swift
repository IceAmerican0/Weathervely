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
    let style: NewClosetTypes
    let closets: [NewClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case counts, style, closets
    }
}

public struct NewClosetTypes: Codable {
    let typeId: Int
    let typeName: String
    
    enum CodingKeys: String, CodingKey {
        case typeId, typeName
    }
}

public struct NewClosetInfo: Codable {
    let closetId: Int
    let closetName: String
    let closetImageUrl: String
    let closetStatus: String
    let closetSiteName: String
    let temperature: NewClosetTemp
    
    enum CodingKeys: String, CodingKey {
        case closetId, closetName, closetImageUrl, closetStatus, closetSiteName, temperature
    }
}

public struct NewClosetTemp: Codable {
    let tempId: Int
    let maxTemp: Int
    let minTemp: Int
    
    enum CodingKeys: String, CodingKey {
        case tempId
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
    }
}

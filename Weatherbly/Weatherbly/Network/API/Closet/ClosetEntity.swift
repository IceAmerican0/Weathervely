//
//  ClosetEntity.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Foundation
import RxDataSources

public struct ClosetEntity: Codable {
    let status: Int
    let data: ClosetData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct ClosetData: Codable {
    let counts: Int
    let closets: [ClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case counts, closets
    }
}

public struct ClosetTypes: Codable {
    let typeId: Int
    let typeName: String
    
    enum CodingKeys: String, CodingKey {
        case typeId, typeName
    }
}

public struct ClosetInfo: Codable {
    let closetId: Int
    let closetName: String
    let closetImageUrl: String
    let closetStatus: String
    let closetSiteName: String
    let temperature: ClosetTemp
    
    enum CodingKeys: String, CodingKey {
        case closetId, closetName, closetImageUrl, closetStatus, closetSiteName, temperature
    }
}

public struct ClosetTemp: Codable {
    let tempId: Int
    let maxTemp: Int
    let minTemp: Int
    
    enum CodingKeys: String, CodingKey {
        case tempId
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
    }
}

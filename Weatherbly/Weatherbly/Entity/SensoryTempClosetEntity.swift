//
//  SensoryTempClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/09.
//

import Foundation

public struct SensoryTempClosetEntity: Codable {
    let status: Int
    let data: SensoryTempClosetData
}

public struct SensoryTempClosetData: Codable {
    let list: [ClosetList]
    let fcstValue: String
}

public struct ClosetList: Codable {
    let id: Int
    let minTemp: String
    let maxTemp: String
    let closetId: Int
    let name: String
    let imageUrl: String
    let typeName: String
    let tempId: Int
    let isTemperatureRange: String

    enum CodingKeys: String, CodingKey {
        case id
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case closetId = "closet_id"
        case name
        case imageUrl = "image_url"
        case typeName = "type_name"
        case tempId = "temp_id"
        case isTemperatureRange
    }
}

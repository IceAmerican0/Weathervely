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
//    let style: [ClosetTypes]?
    let closets: [ClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case counts, /*style,*/ closets
    }
}

public struct ClosetTypes: Codable {
    let typeId: Int
    let typeName: String
    
    enum CodingKeys: String, CodingKey {
        case typeId, typeName
    }
}

public struct ClosetInfo: Codable, Equatable, IdentifiableType {
    public static func == (lhs: ClosetInfo, rhs: ClosetInfo) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    public let identity = UUID().uuidString
    
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

public struct ClosetTemp: Codable, Equatable, IdentifiableType {
    
    public let identity = UUID()
    
    let tempId: Int
    let maxTemp: Int
    let minTemp: Int
    
    enum CodingKeys: String, CodingKey {
        case tempId
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
    }
}

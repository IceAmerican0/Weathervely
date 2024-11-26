//
//  ClosetEntity.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Foundation

public struct ClosetEntity: Codable {
    let status: Int
    public let data: ClosetData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct ClosetData: Codable {
    public let counts: Int
    public let closets: [ClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case counts, closets
    }
}

public struct ClosetTypes: Codable {
    public let typeId: Int
    public let typeName: String
    
    enum CodingKeys: String, CodingKey {
        case typeId, typeName
    }
}

public struct ClosetInfo: Codable {
    public let closetId: Int
    public let closetName: String
    public let closetImageUrl: String
    public let closetStatus: String
    public let closetSiteName: String
    public let temperature: ClosetTemp
    
    public init(
        closetId: Int,
        closetName: String,
        closetImageUrl: String,
        closetStatus: String,
        closetSiteName: String,
        temperature: ClosetTemp
    ) {
        self.closetId = closetId
        self.closetName = closetName
        self.closetImageUrl = closetImageUrl
        self.closetStatus = closetStatus
        self.closetSiteName = closetSiteName
        self.temperature = temperature
    }
    
    enum CodingKeys: String, CodingKey {
        case closetId, closetName, closetImageUrl, closetStatus, closetSiteName, temperature
    }
}

public struct ClosetTemp: Codable {
    public let tempId: Int
    public let maxTemp: Int
    public let minTemp: Int
    
    public init(
        tempId: Int,
        maxTemp: Int,
        minTemp: Int
    ) {
        self.tempId = tempId
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
    
    enum CodingKeys: String, CodingKey {
        case tempId
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
    }
}

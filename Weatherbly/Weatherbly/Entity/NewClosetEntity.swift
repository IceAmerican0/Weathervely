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
    let list: [NewClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case list
    }
}

public struct NewClosetInfo: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let status: String
    let types: [NewClosetType]
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, types
        case imageURL = "image_url"
    }
}

public struct NewClosetType: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

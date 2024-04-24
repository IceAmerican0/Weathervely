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
    let list: NewCloset
    
    enum CodingKeys: String, CodingKey {
        case list
    }
}

public struct NewCloset: Codable {
    let counts: Int
    let closets: [NewClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case counts, closets
    }
}

public struct NewClosetInfo: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let status: String
    let code: String
    let style: NewClosetType
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, code, style
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

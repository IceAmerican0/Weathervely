//
//  StyleTypeEntity.swift
//  Weatherbly
//
//  Created by Khai on 4/30/24.
//

import Foundation

public struct StyleTypeEntity: Codable {
    let status: Int
    let data: StyleTypeData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct StyleTypeData: Codable {
    let types: [StyleTypeInfo]
    
    enum CodingKeys: String, CodingKey {
        case types
    }
}

public struct StyleTypeInfo: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

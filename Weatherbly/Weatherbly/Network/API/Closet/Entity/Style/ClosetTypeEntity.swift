//
//  ClosetTypeEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/20/24.
//

import Foundation
import RxDataSources

public struct ClosetTypeEntity: Codable {
    let status: Int
    let data: ClosetTypeData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct ClosetTypeData: Codable {
    let types: [ClosetTypeInfo]
    
    enum CodingKeys: String, CodingKey {
        case types
    }
}

public struct ClosetTypeInfo: Codable, Equatable, IdentifiableType {
    public let identity: String = UUID().uuidString
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

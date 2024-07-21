//
//  CategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/4/24.
//

import Foundation
import RxDataSources

struct CategoryEntity: Codable {
    
    var status: Int
    var data: MCategoryData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct MCategoryData: Codable {
    var mediumCategories: [MCategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

public struct MCategoryInfo: Codable, Equatable, IdentifiableType {

    public var identity = UUID().uuidString
    
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}



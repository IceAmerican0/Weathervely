//
//  StyleMediumCategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import Foundation
import RxDataSources

public struct StyleMediumCategoryEntity: Codable {
    var status: Int
    var data: StyleMediumCategoryData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct StyleMediumCategoryData: Codable {
    var mediumCategories: [StyleMediumCategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

public struct StyleMediumCategoryInfo: Codable, Equatable, IdentifiableType {
    public var identity = UUID().uuidString
    
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

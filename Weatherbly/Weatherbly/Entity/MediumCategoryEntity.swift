//
//  MediumCategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import Foundation

public struct MediumCategoryEntity: Codable {
    var status: Int
    var data: MediumCategoryData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct MediumCategoryData: Codable {
    var mediumCategories: [MediumCategoryList]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

public struct MediumCategoryList: Codable {
    var category: String
    var items: [MediumCategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case category, items
    }
}

public struct MediumCategoryInfo: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

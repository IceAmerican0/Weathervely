//
//  StyleMediumCategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import Foundation

public struct StyleMediumCategoryEntity: Codable {
    var status: Int
    var data: StyleMediumCategoryData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct StyleMediumCategoryData: Codable {
    var mediumCategories: [StyleMediumCategoryList]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

public struct StyleMediumCategoryList: Codable {
    var category: String
    var items: [StyleMediumCategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case category, items
    }
}

public struct StyleMediumCategoryInfo: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

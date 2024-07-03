//
//  MainMediumCategoryEntity.swift
//  Weatherbly
//
//  Created by Khai on 7/2/24.
//

import Foundation

public struct MainMediumCategoryEntity: Codable {
    var status: Int
    var data: MainMediumCategoryData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct MainMediumCategoryData: Codable {
    var mediumCategories: [MainMediumCategoryList]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

public struct MainMediumCategoryList: Codable {
    var category: String
    var items: [MainMediumCategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case category, items
    }
}

public struct MainMediumCategoryInfo: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

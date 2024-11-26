//
//  MainMediumCategoryEntity.swift
//  Weatherbly
//
//  Created by Khai on 7/2/24.
//

import Foundation
import RxDataSources

public struct MainMediumCategoryEntity: Codable {
    var status: Int
    public var data: MainMediumCategoryData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct MainMediumCategoryData: Codable {
    public var mediumCategories: [MainMediumCategoryList]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

public struct MainMediumCategoryList: Codable {
    public var category: String
    public var items: [CategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case category, items
    }
}

public struct CategoryInfo: Codable {
    public var id: Int
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

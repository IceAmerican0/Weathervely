//
//  MainMediumCategoryEntity.swift
//  Weatherbly
//
//  Created by Khai on 7/2/24.
//

import Foundation

// mediumCategory API response 변경 됐음으로 새 entitiy로 교체
// 빌드시 에러 때문에 이거는 두고 같은 API에 사용되는 CategoryEntity로 변경
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

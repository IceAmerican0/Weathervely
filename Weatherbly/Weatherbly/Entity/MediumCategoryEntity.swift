//
//  MediumCategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import Foundation


// mediumCategory API response 변경 됐음으로 새 entitiy로 교체
// 빌드시 에러 때문에 이거는 두고 같은 API에 사용되는 CategoryEntity로 변경
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

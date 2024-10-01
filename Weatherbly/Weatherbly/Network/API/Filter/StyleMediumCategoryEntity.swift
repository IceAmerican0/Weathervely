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
    var mediumCategories: [CategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategories
    }
}

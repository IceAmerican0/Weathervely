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
}

public struct MediumCategoryData: Codable {
    var mediumCategories: [MediumCategoryList]
}

public struct MediumCategoryList: Codable {
    var category: String
    var items: [MediumCategoryInfo]
}

public struct MediumCategoryInfo: Codable {
    var id: Int
    var name: String
}

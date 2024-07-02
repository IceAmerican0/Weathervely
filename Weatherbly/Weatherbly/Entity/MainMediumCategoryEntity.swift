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
    var mediumCategoriesMain: [MainMediumCategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case mediumCategoriesMain
    }
}

public struct MainMediumCategoryInfo: Codable {
    var id: Int
    var name: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case id = "mc_id"
        case name = "mc_name"
        case category = "lc_name"
    }
}

public struct MainMediumCategoryListSorted {
    var category: String
    var items: [MainMediumCategoryInfoSorted]
}

public struct MainMediumCategoryInfoSorted {
    var id: Int
    var name: String
}

public func sortMainMediumCategoryList(_ list: [MainMediumCategoryInfo]) -> [MainMediumCategoryListSorted] {
    // 같은 카테고리끼리 그룹화
    let categories = Dictionary(grouping: list, by: { $0.category })
    
    // 구조에 맞게 넣어줌
    return categories.map { category, items in
        MainMediumCategoryListSorted(
            category: category,
            items: items.map {
                MainMediumCategoryInfoSorted(
                    id: $0.id,
                    name: $0.name
                )
            }
        )
    }
}

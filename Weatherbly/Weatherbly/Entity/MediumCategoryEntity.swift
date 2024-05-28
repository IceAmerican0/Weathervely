//
//  MediumCategoryEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/25/24.
//

import Foundation

struct MediumCategoryEntity {
    var status: Int
    var data: MediumCategoryData
}

struct MediumCategoryData {
    var categories: [MediumCategoryInfo]
}

struct MediumCategoryInfo {
    var id: Int
    var name: String
}

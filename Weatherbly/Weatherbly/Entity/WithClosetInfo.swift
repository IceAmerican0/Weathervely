//
//  WithClosetInfo.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation

struct WithItemsInfo: Codable {
    var category: CategoryInfo?
    var id: Int
    var name: String?
    var status: String?
    var shopUrl: String?
    var imageUrl: String?
    var brandName: String?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case id = "clotheId"
        case name = "clotheName"
        case status = "clotheStatus"
        case shopUrl = "clothesSiteUrl"
        case imageUrl = "clothesImageUrl"
        case brandName = "clothesBrandName"
    }
}

struct CategoryInfo: Codable {
    var categoryName: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
    }
}

//
//  WithClosetInfo.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation

struct WithItemsInfo: Codable {
    var category: ItemCategoryInfo?
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
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.category, forKey: .category)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.shopUrl, forKey: .shopUrl)
        try container.encodeIfPresent(self.imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(self.brandName, forKey: .brandName)
    }
}

struct ItemCategoryInfo: Codable {
    var categoryName: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
    }
}

//
//  WithClosetInfo.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation
import RxDataSources

public struct WithItemsInfo: Codable, Equatable, IdentifiableType {
    public static func == (lhs: WithItemsInfo, rhs: WithItemsInfo) -> Bool {
        return lhs.identity == rhs.identity
    }
    public let identity = UUID()
    public var id: Int
    public var category: ItemCategoryInfo?
    public var name: String?
    public var status: String?
    public var shopUrl: String?
    public var imageUrl: String?
    public var brandName: String?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case id = "clotheId"
        case name = "clotheName"
        case status = "clotheStatus"
        case shopUrl = "clothesSiteUrl"
        case imageUrl = "clothesImageUrl"
        case brandName = "clothesBrandName"
    }
    
    public func encode(to encoder: any Encoder) throws {
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

public struct ItemCategoryInfo: Codable {
    public var categoryName: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
    }
}

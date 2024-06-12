//
//  SelectedClosetInfo.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation

struct SelectedClosetInfo: Codable {
    var id: Int
    var name: String
    var imageUrl: String?
    var shopName: String?
    var style: SelectedClosetTypeInfo
    var withItems: [WithItemsInfo]?
    
    enum CodingKeys: String, CodingKey {
        case id = "closetId"
        case name = "closetName"
        case imageUrl = "closetImageUrl"
        case shopName = "closetSiteName"
        case style = "style"
        case withItems = "clothes"
    }
}

struct SelectedClosetTypeInfo: Codable {
    var typeId: Int
    var typeName: String

}

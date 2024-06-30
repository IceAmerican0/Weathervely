//
//  ClosetDetailEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation

struct ClosetDetailEntity: Codable{
    var status: Int
    var data: ClosetDetailData?
}

struct ClosetDetailData: Codable {
    var selectedCloset: SelectedClosetInfo?
    
    enum CodingKeys: String, CodingKey {
        case selectedCloset = "closet"
    }
}

struct SelectedClosetInfo: Codable {
    var id: Int
    var name: String
    var imageUrl: String?
    var shopName: String?
    var style: SelectedClosetTypeInfo
    var temp: TemperatureEntity
    var withItems: [WithItemsInfo]?
    
    enum CodingKeys: String, CodingKey {
        case id = "closetId"
        case name = "closetName"
        case imageUrl = "closetImageUrl"
        case shopName = "closetSiteName"
        case style = "style"
        case temp = "temperature"
        case withItems = "clothes"
    }
}

struct SelectedClosetTypeInfo: Codable {
    var typeId: Int
    var typeName: String

}

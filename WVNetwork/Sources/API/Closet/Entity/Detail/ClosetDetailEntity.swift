//
//  ClosetDetailEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation
import RxDataSources

public struct ClosetDetailEntity: Codable {
    var status: Int
    public var data: ClosetDetailData?
}

public struct ClosetDetailData: Codable {
    public var selectedCloset: SelectedClosetInfo?
    
    enum CodingKeys: String, CodingKey {
        case selectedCloset = "closet"
    }
}

public struct SelectedClosetInfo: Codable, Equatable, IdentifiableType {
    public static func == (lhs: SelectedClosetInfo, rhs: SelectedClosetInfo) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    public let identity = UUID()
    public var id: Int
    public var name: String
    public var imageUrl: String?
    public var shopName: String?
    public var style: SelectedClosetTypeInfo
    public var temp: TemperatureEntity
    public var withItems: [WithItemsInfo]?
    
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

public struct SelectedClosetTypeInfo: Codable {
    var typeId: Int
    var typeName: String
}

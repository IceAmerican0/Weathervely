//
//  DiffTempRows.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import Foundation
import RxDataSources

public struct DiffTempRows: Codable {
    public var counts: Int?
    public var closets: [RowInfo]?
}

public struct RowInfo: Codable, Equatable, IdentifiableType {
    public let identity = UUID()
    
    public var closetId: Int
    public var closetName: String
    public var closetImageUrl: String
    public var closetStatus: String
    public var temperature: TemperatureEntity
    
    enum CodingKeys: String, CodingKey {
        case closetId = "closetId"
        case closetName = "closetName"
        case closetImageUrl = "closetImageUrl"
        case closetStatus = "closetStatus"
        case temperature = "temperature"
    }
}

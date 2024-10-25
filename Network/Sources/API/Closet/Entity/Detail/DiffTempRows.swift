//
//  DiffTempRows.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import Foundation
import RxDataSources

public struct DiffTempRows: Codable {
    var counts: Int?
    var closets: [RowInfo]?
}

public struct RowInfo: Codable, Equatable, IdentifiableType {
    let identity = UUID()
    
    var closetId: Int
    var closetName: String
    var closetImageUrl: String
    var closetStatus: String
    var temperature: TemperatureEntity
    
    enum CodingKeys: String, CodingKey {
        case closetId = "closetId"
        case closetName = "closetName"
        case closetImageUrl = "closetImageUrl"
        case closetStatus = "closetStatus"
        case temperature = "temperature"
    }
}

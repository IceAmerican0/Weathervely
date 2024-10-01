//
//  ClosetTypeEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/20/24.
//

import Foundation
import RxDataSources

public struct ClosetTypeEntity: Codable {
    let status: Int
    let data: ClosetTypeData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct ClosetTypeData: Codable {
    let types: [CategoryInfo]
    
    enum CodingKeys: String, CodingKey {
        case types
    }
}

//
//  TemperatureEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/29/24.
//

import Foundation

struct TemperatureEntity: Codable {
    var tempId: Int
    
    enum CodingKeys: String, CodingKey {
        case tempId
    }
}

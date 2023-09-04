//
//  StatusOnlyEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import Foundation

public struct StatusOnlyEntity: Decodable {
    var status: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    
}

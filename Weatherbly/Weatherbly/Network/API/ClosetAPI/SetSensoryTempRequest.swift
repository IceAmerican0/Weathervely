//
//  SetSensoryTempRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/18.
//

public struct SetSensoryTempRequest: Codable {
    let closet: Int
    let currentTemp: String
    
    enum CodingKeys: String, CodingKey {
        case closet, currentTemp
    }
}

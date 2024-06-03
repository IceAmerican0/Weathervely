//
//  HomeFilterCountEntity.swift
//  Weatherbly
//
//  Created by Khai on 6/3/24.
//

import Foundation

public struct HomeFilterCountEntity: Codable {
    let status: Int
    let data: HomeFilterCount
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct HomeFilterCount: Codable {
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}

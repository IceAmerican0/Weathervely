//
//  StyleClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/18/24.
//

import Foundation

public struct StyleClosetEntity: Codable {
    let status: Int
    let data: StyleClosetData
}

public struct StyleClosetData: Codable {
    let list: [StyleClosetInfo]
    let count: Int
}

public struct StyleClosetInfo: Codable {
    let url: String
    let shopName: String
}
        
        

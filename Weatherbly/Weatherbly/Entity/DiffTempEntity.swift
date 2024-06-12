//
//  WarmmerClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import Foundation

struct DiffTempEntity: Codable {
    var status: Int
    var data: DiffTempData?
}

struct DiffTempData: Codable {
    var list: DiffTempClosetList?
}

struct DiffTempClosetList: Codable {
    var firstRow: FirstRow?
    var secondRow: SecondRow?
    
    enum CodingKeys: String, CodingKey {
        case firstRow = "row1"
        case secondRow = "row2"
    }
}


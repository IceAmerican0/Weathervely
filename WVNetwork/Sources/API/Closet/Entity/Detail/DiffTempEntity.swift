//
//  WarmmerClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import Foundation

public struct DiffTempEntity: Codable {
    var status: Int
    public var data: DiffTempData?
}

public struct DiffTempData: Codable {
    public var list: DiffTempClosetList?
}

public struct DiffTempClosetList: Codable {
    public var firstRow: DiffTempRows?
    public var secondRow: DiffTempRows?
    
    enum CodingKeys: String, CodingKey {
        case firstRow = "row1"
        case secondRow = "row2"
    }
}


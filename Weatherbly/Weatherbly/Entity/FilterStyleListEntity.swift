//
//  FilterStyleListEntity.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import Foundation

public struct FilterStyleListEntity: Codable {
    let status: Int
    let data: FilterStyleListData
}

public struct FilterStyleListData: Codable {
//    let list: [FilterStyleInfo]
}

public struct FilterStyleListInfo {
    let id: Int
    let title: String
}

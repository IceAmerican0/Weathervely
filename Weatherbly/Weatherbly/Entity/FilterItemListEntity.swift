//
//  FilterItemListEntity.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import Foundation

public struct FilterItemListEntity: Codable {
    let status: Int
    let data: FilterItemListData
}

public struct FilterItemListData: Codable {
//    let list: [FilterItemList]
}

public struct FilterItemList {
    let header: String
    let info: [FilterItemListInfo]
}

public struct FilterItemListInfo {
    let id: Int
    let title: String
}

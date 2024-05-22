//
//  ClosetTypeEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/20/24.
//

import Foundation

struct ClosetTypeEntity {
    let status: Int
    let data: ClosetTypeData
}

struct ClosetTypeData {
    let types: [ClosetTypeInfo]
}

struct ClosetTypeInfo {
    let id: Int
    let name: String
}

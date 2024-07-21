//
//  ClosetTypeEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/20/24.
//

import Foundation
import RxDataSources

struct ClosetTypeEntity: Decodable {
    let status: Int
    let data: ClosetTypeData
}

struct ClosetTypeData: Decodable {
    let types: [ClosetTypeInfo]
}

struct ClosetTypeInfo: Decodable, Equatable, IdentifiableType {
    let identity: String = UUID().uuidString
    
    let id: Int
    let name: String
}

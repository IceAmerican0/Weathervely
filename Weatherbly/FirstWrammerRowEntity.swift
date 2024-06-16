//
//  FirstWrammerRowEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/7/24.
//

import Foundation

struct Rows: Codable {
    var counts: Int
    var closets: [RowInfo]
}

struct RowInfo: Codable {
    var closetId: Int
    var closetName: String
    var closetImageUrl: String
    var closetStatus: String
}

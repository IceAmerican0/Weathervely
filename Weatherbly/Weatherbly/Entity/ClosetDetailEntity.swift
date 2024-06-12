//
//  ClosetDetailEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/6/24.
//

import Foundation

struct ClosetDetailEntity: Codable{
    var status: Int
    var data: ClosetDetailData?
}

struct ClosetDetailData: Codable {
    var selectedCloset: SelectedClosetInfo?
    
    enum CodingKeys: String, CodingKey {
        case selectedCloset = "closet"
    }
}


//
//  UserInfoEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/10.
//

import Foundation

public struct UserInfoEntity: Codable {
    var id: Int?
    var nickname: String?
    var gender: String?
    
    enum CodingKeys: String, CodingKey {
        case id, nickname, gender
    }
}

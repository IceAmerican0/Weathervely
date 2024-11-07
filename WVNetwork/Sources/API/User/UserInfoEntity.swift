//
//  UserInfoEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/10.
//

import Foundation

public struct UserInfoEntity: Codable {
    public var id: Int?
    public var nickname: String?
    public var gender: String?
    
    enum CodingKeys: String, CodingKey {
        case id, nickname, gender
    }
}

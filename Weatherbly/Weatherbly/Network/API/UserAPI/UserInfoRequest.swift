//
//  UserInfoRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/08.
//

public struct UserInfoRequest: Codable {
    var nickname: String
    var gender: String
    
    enum CodingKeys: String, CodingKey {
        case nickname, gender
    }
}

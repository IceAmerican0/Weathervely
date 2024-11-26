//
//  UserInfoRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/08.
//

public struct UserInfoRequest: Codable {
    public var nickname: String
//    var gender: String
    
    public init(nickname: String) {
        self.nickname = nickname
    }
    
    enum CodingKeys: String, CodingKey {
        case nickname//, gender
    }
}

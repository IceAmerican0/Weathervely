//
//  AuthLoginEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/21.
//

import Foundation

public struct AuthLoginEntity: Codable {
    var status: Int
    var data: AuthData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct AuthData: Codable {
    var user: UserInfo
    var address: AddressIDInfo?
    var setTemperature: Bool
    
    enum CodingKeys: String, CodingKey {
        case user, address, setTemperature
    }
}

public struct UserInfo: Codable {
    var id: Int
    var nickname: String
    
    enum CodingKeys: String, CodingKey {
        case id, nickname
    }
}


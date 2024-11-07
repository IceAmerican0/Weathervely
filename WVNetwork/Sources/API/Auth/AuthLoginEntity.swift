//
//  AuthLoginEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/21.
//

import Foundation

public struct AuthLoginEntity: Codable {
    var status: Int
    public var data: AuthData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

public struct AuthData: Codable {
    public var user: UserInfo
    public var address: AddressIDInfo?
    public var version: String?
    public var canUpdate: Bool
    public var latestVersion: String
    
    enum CodingKeys: String, CodingKey {
        case user, address, version, canUpdate, latestVersion
    }
}

public struct UserInfo: Codable {
    public var id: Int
    public var nickname: String
    
    enum CodingKeys: String, CodingKey {
        case id, nickname
    }
}


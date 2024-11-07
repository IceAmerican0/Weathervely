//
//  AddressEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/09.
//

import Foundation

public struct AddressEntity: Codable {
    let status: Int
    public let data: AddressBody?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

public struct AddressBody: Codable {
    public let list: [AddressInfo]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct AddressInfo: Codable {
    public var address_name: String?
    public var city: String?
    public var gu: String?
    public var dong: String?
    public var country: String?
    public var x_code: Int?
    public var y_code: Int?
    
    enum CodingKeys: String, CodingKey {
        case address_name, city, gu, dong, country, x_code, y_code
    }
}

public struct AddressIDInfo: Codable {
    public var id: Int
    public var address_name: String
    public var city: String
    public var gu: String
    public var dong: String
    public var country: String
    public var x_code: String
    public var y_code: String
    
    enum CodingKeys: String, CodingKey {
        case id, address_name, city, gu, dong, country, x_code, y_code
    }
}

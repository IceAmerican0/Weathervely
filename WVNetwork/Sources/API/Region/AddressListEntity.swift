//
//  AddressListEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/17.
//

import Foundation

public struct AddressListEntity: Codable {
    let status: Int
    public let data: AddressListBody?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

public struct AddressListBody: Codable {
    public let list: [AddressListInfo]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct AddressListInfo: Codable {
    public let id: Int
    public let addressName: String
    public let dong: String
    public let isMainAddress: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case addressName = "address_name"
        case dong = "dong"
        case isMainAddress = "is_main_address"
    }
}

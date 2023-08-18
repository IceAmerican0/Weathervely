//
//  AddressListEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/17.
//

import Foundation

public struct AddressListEntity: Codable {
    let status: Int
    let data: AddressListBody?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

public struct AddressListBody: Codable {
    let list: [AddressListInfo]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct AddressListInfo: Codable {
    let id: Int
    let addressName: String
    let isMainAddress: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case addressName = "address_name"
        case isMainAddress = "is_main_address"
    }
}

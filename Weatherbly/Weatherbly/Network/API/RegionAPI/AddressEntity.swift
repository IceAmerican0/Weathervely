//
//  AddressEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/09.
//

import Foundation

public struct AddressEntity: Codable {
    let status: Int
    let data: AddressBody?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

public struct AddressBody: Codable {
    let list: [AddressInfo]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct AddressInfo: Codable {
    var address_name: String?
    var city: String?
    var gu: String?
    var dong: String?
    var country: String?
    var x_code: Int?
    var y_code: Int?
    
    enum CodingKeys: String, CodingKey {
        case address_name, city, gu, dong, country, x_code, y_code
    }
}

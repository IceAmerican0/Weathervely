//
//  AddressRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

public struct AddressRequest: Codable {
    var address_name: String?
    var city: String?
    var gu: String?
    var dong: String?
    var country: String?
    var x_code: Double?
    var y_code: Double?
    
    enum CodingKeys: String, CodingKey {
        case address_name, city, gu, dong, country, x_code, y_code
    }
}

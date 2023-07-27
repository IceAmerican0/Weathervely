//
//  AddressRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

public struct AddressRequest: Encodable {
    var address_name: String?
    var city: String?
    var gu: String?
    var dong: String?
    var postal_code: String?
    var country: String?
    var x_code: String?
    var y_code: String?
    
    enum CodingKeys: String, CodingKey {
        case address_name, city, gu, dong, postal_code, country, x_code, y_code
    }
}

//
//  AddressRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

public struct AddressRequest: Codable {
    public var address_name: String?
    public var city: String?
    public var gu: String?
    public var dong: String?
    public var country: String?
    public var x_code: Double?
    public var y_code: Double?
    
    public init(
        address_name: String? = nil,
        city: String? = nil,
        gu: String? = nil,
        dong: String? = nil,
        country: String? = nil,
        x_code: Double? = nil,
        y_code: Double? = nil
    ) {
        self.address_name = address_name
        self.city = city
        self.gu = gu
        self.dong = dong
        self.country = country
        self.x_code = x_code
        self.y_code = y_code
    }
    
    enum CodingKeys: String, CodingKey {
        case address_name, city, gu, dong, country, x_code, y_code
    }
}

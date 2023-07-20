//
//  RegionInfo.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/17.
//

/// 주소 검색 결과
public struct RegionInfo {
    public var documents: [Documents]
    
    public init(documents: [Documents]) {
        self.documents = documents
    }
}

public struct Documents {
    /// 경도
    public let longitude: String
    /// 위도
    public let latitude: String
    /// 주소 상세
    public var address: [Address]
    
    public init(longitude: String, latitude: String, address: [Address]) {
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
}

public struct Address {
    /// 지역명 1
    public let region1: String
    /// 지역명 2
    public let region2: String
    /// 지역명 3
    public let region3: String
    
    public init(region1: String, region2: String, region3: String) {
        self.region1 = region1
        self.region2 = region2
        self.region3 = region3
    }
}

/*
"address_name": "전북 익산시 부송동 100",
      "y": "35.97664845766847",
      "x": "126.99597295767953",
      "address_type": "REGION_ADDR",
      "address": {
        "address_name": "전북 익산시 부송동 100",
        "region_1depth_name": "전북",
        "region_2depth_name": "익산시",
        "region_3depth_name": "부송동",
        "region_3depth_h_name": "삼성동",
        "h_code": "4514069000",
        "b_code": "4514013400",
        "mountain_yn": "N",
        "main_address_no": "100",
        "sub_address_no": "",
        "x": "126.99597295767953",
        "y": "35.97664845766847"
      },
*/

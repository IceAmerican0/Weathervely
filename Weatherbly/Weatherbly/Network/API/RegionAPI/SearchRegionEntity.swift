//
//  SearchRegionEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation

public struct SearchRegionEntity: Codable {
    let meta: Meta
    let documents: [Document]
}

public struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

public struct Document: Codable {
    let addressName: String
    let y: String
    let x: String
    let addresstype: String
    let address: Address
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case y
        case x
        case addresstype = "address_type"
        case address
    }
}

public struct Address: Codable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthHName: String
    let region3DepthName: String
    let hCode: String
    let bCode: String
    let mountainYN: String
    let mainAddressNo: String
    let subAddressNo: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthHName = "region_3depth_h_name"
        case region3DepthName = "region_3depth_name"
        case hCode = "h_code"
        case bCode = "b_code"
        case mountainYN = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
        case x
        case y
    }
}

public struct RoadAddress: Codable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let roadName: String
    let undergroundYN: String
    let mainBuildingNo: String
    let subBuildingNo: String
    let buildingName: String
    let zoneNo: String
    let y: String
    let x: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case undergroundYN = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case zoneNo = "zone_no"
        case y
        case x
    }
}

/// Ex.
//{
//  "meta": {
//    "total_count": 4,
//    "pageable_count": 4,
//    "is_end": true
//  },
//  "documents": [
//    {
//      "address_name": "전북 익산시 부송동 100",
//      "y": "35.97664845766847",
//      "x": "126.99597295767953",
//      "address_type": "REGION_ADDR",
//      "address": {
//        "address_name": "전북 익산시 부송동 100",
//        "region_1depth_name": "전북",
//        "region_2depth_name": "익산시",
//        "region_3depth_name": "부송동",
//        "region_3depth_h_name": "삼성동",
//        "h_code": "4514069000",
//        "b_code": "4514013400",
//        "mountain_yn": "N",
//        "main_address_no": "100",
//        "sub_address_no": "",
//        "x": "126.99597295767953",
//        "y": "35.97664845766847"
//      },
//      "road_address": {
//        "address_name": "전북 익산시 망산길 11-17",
//        "region_1depth_name": "전북",
//        "region_2depth_name": "익산시",
//        "region_3depth_name": "부송동",
//        "road_name": "망산길",
//        "underground_yn": "N",
//        "main_building_no": "11",
//        "sub_building_no": "17",
//        "building_name": "",
//        "zone_no": "54547",
//        "y": "35.976749396987046",
//        "x": "126.99599512792346"
//      }
//    },
//    ...
//  ]
//}

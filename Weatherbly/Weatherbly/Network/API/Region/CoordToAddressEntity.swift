//
//  CoordToAddressEntity.swift
//  Weatherbly
//
//  Created by Khai on 9/26/24.
//

import Foundation

public struct CoordToAddressEntity: Codable {
    let meta: CoordMeta
    let documents: [CoordDocument]
    
    public init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           
           let allDocuments = try container.decode([CoordDocument].self, forKey: .documents)
           self.documents = allDocuments.filter { document in
               var isAddressValid = true
               var isRoadAddressValid = true
               
               if let addr = document.address {
                   isAddressValid = !addr.region3DepthName.isEmpty
               }
               
               if let roadAddr = document.roadAddress {
                   isRoadAddressValid = !roadAddr.region3DepthName.isEmpty
               }
               
               return isAddressValid && isRoadAddressValid
           }
           
           self.meta = try container.decode(CoordMeta.self, forKey: .meta)
       }
}

public struct CoordMeta: Codable {
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

public struct CoordDocument: Codable {
    let address: CoordAddress?
    let roadAddress: CoordRoadAddress?
    
    enum CodingKeys: String, CodingKey {
        case address
        case roadAddress = "road_address"
    }
}

public struct CoordAddress: Codable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let mountainYN: String
    let mainAddressNo: String
    let subAddressNo: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYN = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
    }
}

public struct CoordRoadAddress: Codable {
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
    }
}

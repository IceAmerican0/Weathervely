//
//  SearchRegionEntity.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation

//public struct SearchRegionEntity: Decodable {
//
//    public let meta: [MetaList]?
//
//    public let documents: [DocumentList]
//
//    public struct MetaList: Decodable {
//        public let total_count: Int?
//        public let pageable_count: Int?
//        public let is_end: Bool?
//    }
//
//    public struct DocumentList: Decodable {
//        public let address_name: String?
//        public let y: String?
//        public let x: String?
//        public let address_type: String?
//        public let address: [AddressList]
//        public let road_address: [RoadList]?
//    }
//
//    public struct AddressList: Decodable {
//        public let address_name: String?
//        public let region_1depth_name: String?
//        public let region_2depth_name: String?
//        public let region_3depth_name: String?
//        public let region_3depth_h_name: String?
//        public let h_code: String?
//        public let b_code: String?
//        public let mountain_yn: String?
//        public let main_address_no: String?
//        public let sub_address_no: String?
//        public let x: String?
//        public let y: String?
//    }
//
//    public struct RoadList: Decodable {
//        public let address_name: String?
//        public let region_1depth_name: String?
//        public let region_2depth_name: String?
//        public let region_3depth_name: String?
//        public let road_name: String?
//        public let underground_yn: String?
//        public let main_building_no: String?
//        public let sub_building_no: String?
//        public let zone_no: String?
//        public let y: String?
//        public let x: String?
//    }
//}

public struct SearchRegionEntity: Codable {
    struct Meta: Codable {
        let totalCount: Int
        let pageableCount: Int
        let isEnd: Bool
        
        private enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
    }
    
    struct Document: Codable {
        let addressName: String
        let y: String
        let x: String
        
        struct Address: Codable {
            let addressName: String
            let region1DepthName: String
            let region2DepthName: String
            let region3DepthName: String
            let region3DepthHName: String
            let hCode: String
            let bCode: String
            let mountainYN: String
            let mainAddressNo: String
            let subAddressNo: String
            let x: String
            let y: String
            
            private enum CodingKeys: String, CodingKey {
                case addressName = "address_name"
                case region1DepthName = "region_1depth_name"
                case region2DepthName = "region_2depth_name"
                case region3DepthName = "region_3depth_name"
                case region3DepthHName = "region_3depth_h_name"
                case hCode = "h_code"
                case bCode = "b_code"
                case mountainYN = "mountain_yn"
                case mainAddressNo = "main_address_no"
                case subAddressNo = "sub_address_no"
                case x
                case y
            }
        }
        
        struct RoadAddress: Codable {
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
            
            private enum CodingKeys: String, CodingKey {
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
        
        let address: Address
        
        private enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case y
            case x
            case address
        }
    }
    
    let meta: Meta
    let documents: [Document]
}

//
//  SearchRegionResponse.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation

public struct SearchRegionResponse: Decodable {
    
    public let meta: [MetaList]?
    
    public let documents: [DocumentList]
    
    public struct MetaList: Decodable {
        public let total_count: Int?
        public let pageable_count: Int?
        public let is_end: Bool?
    }
    
    public struct DocumentList: Decodable {
        public let address_name: String?
        public let y: String?
        public let x: String?
        public let address_type: String?
        public let address: [AddressList]
        public let road_address: [RoadList]?
    }
    
    public struct AddressList: Decodable {
        public let address_name: String?
        public let region_1depth_name: String?
        public let region_2depth_name: String?
        public let region_3depth_name: String?
        public let region_3depth_h_name: String?
        public let h_code: String?
        public let b_code: String?
        public let mountain_yn: String?
        public let main_address_no: String?
        public let sub_address_no: String?
        public let x: String?
        public let y: String?
    }
    
    public struct RoadList: Decodable {
        public let address_name: String?
        public let region_1depth_name: String?
        public let region_2depth_name: String?
        public let region_3depth_name: String?
        public let road_name: String?
        public let underground_yn: String?
        public let main_building_no: String?
        public let sub_building_no: String?
        public let zone_no: String?
        public let y: String?
        public let x: String?
    }
}

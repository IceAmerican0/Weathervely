//
//  RecommendClosetEntity.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/05.
//

import Foundation

public struct RecommendClosetEntity: Codable {
    let status: Int
    let data: RecommendClosetData?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

public struct RecommendClosetData: Codable {
    let list: RecommendClosetBody
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct RecommendClosetBody: Codable {
    let closets: [RecommendClosetInfo]
//    let userSensoryTemperature: Float
    
    enum CodingKeys: String, CodingKey {
        case closets = "closets"
//        case userSensoryTemperature = "userSensoryTemperature"
    }
}

public struct RecommendClosetInfo: Codable {
    let id: Int
    let name: String
    let shopName: String
    let shopUrl: String
    let imageUrl: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case shopName = "site_name"
        case shopUrl = "site_url"
        case imageUrl = "image_url"
        case status = "status"
    }
}

/*
 {
        "id": 1,
        "name": "썸머트위드미니OPS",
        "site_name": "66girls",
        "site_url": "https://www.66girls.co.kr/product/ll-%EC%8D%B8%EB%A8%B8%ED%8A%B8%EC%9C%84%EB%93%9C%EB%AF%B8%EB%8B%88ops-2size/135097/category/411/display/1/",
        "image_url": "https://weatherbly.s3.ap-northeast-2.amazonaws.com/image/135097.jpg",
        "status": "Active",
        "is_onboarding": 0
      },
      {
        "id": 2,
        "name": "폴셋라운드반팔jk",
        "site_name": "66girls",
        "site_url": "https://www.66girls.co.kr/product/%ED%8F%B4%EC%85%8B%EB%9D%BC%EC%9A%B4%EB%93%9C%EB%B0%98%ED%8C%94jk/134128/category/108/display/1/",
        "image_url": "https://weatherbly.s3.ap-northeast-2.amazonaws.com/image/134128.jpg",
        "status": "Active",
        "is_onboarding": 0
      },
 */

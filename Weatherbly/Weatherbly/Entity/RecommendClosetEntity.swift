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

struct RecommendClosetData: Codable {
    let list: [RecommendClosetInfo]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

public struct RecommendClosetInfo: Codable {
    let id: Int
    let name: String
    let minTemp: String
    let maxTemp: String
    let shopName: String
    let shopUrl: String
    let imageUrl: String
    let status: String
    let isOnboding: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case shopName = "site_name"
        case shopUrl = "site_url"
        case imageUrl = "image_url"
        case status = "status"
        case isOnboding = "is_onboarding"
    }
}

/*
 {
        "id": 5,
        "name": "워싱코튼루즈숏팬츠",
        "min_temp": "26",
        "max_temp": "32",
        "site_name": "66girls",
        "site_url": "https://66girls.co.kr/product/%EC%9B%8C%EC%8B%B1%EC%BD%94%ED%8A%BC%EB%A3%A8%EC%A6%88%EC%88%8F%ED%8C%AC%EC%B8%A0/135978/category/756/display/1/",
        "image_url": "https://weatherbly.s3.ap-northeast-2.amazonaws.com/image/135978.jpg",
        "status": "Active",
        "is_onboarding": 0
      },
      {
        "id": 6,
        "name": "아일렛버튼레이스나시",
        "min_temp": "26",
        "max_temp": "29",
        "site_name": "66girls",
        "site_url": "https://66girls.co.kr/product/%EC%95%84%EC%9D%BC%EB%A0%9B%EB%B2%84%ED%8A%BC%EB%A0%88%EC%9D%B4%EC%8A%A4%EB%82%98%EC%8B%9C/135584/category/122/display/1/",
        "image_url": "https://weatherbly.s3.ap-northeast-2.amazonaws.com/image/135584.jpg",
        "status": "Active",
        "is_onboarding": 0
      }
 */

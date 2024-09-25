//
//  RegionTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation
import Moya

public enum RegionTarget {
    case searchRegion(_ query: String)
    case coordToAddress(longitude: String, latitude: String)
}

extension RegionTarget: WVTargetType {
    public var baseURL: URL {
        guard let baseURL = URL(string: "https://dapi.kakao.com/v2/local") else {
            fatalError("BaseURL 세팅 실패")
        }
        return baseURL
    }
    
    public var method: Moya.Method { .get }
    
    public var path: String {
        switch self {
        case .searchRegion: 
            "/search/address"
        case .coordToAddress(let longitude, let latitude):
            "/geo/coord2address?x=\(longitude)&y=\(latitude)"
        }
    }
    
    public var headers: [String : String]? {
        ["Authorization": "KakaoAK \(Constants.kakaoAppKeyRest)"]
    }
    
    public var task: Task {
        switch self {
        case .searchRegion(let query):
            .requestParameters(
                parameters: ["query": query],
                encoding: URLEncoding.queryString
            )
        case .coordToAddress:
            .requestPlain
        }
    }
}

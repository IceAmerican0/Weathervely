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
}

extension RegionTarget: WVTargetType {
    public var baseURL: URL {
        guard let baseURL = URL(string: "https://dapi.kakao.com/v2/local/search/address.json") else {
            fatalError("BaseURL 세팅 실패")
        }
        return baseURL
    }
    
    public var method: Moya.Method { .get }
    
    public var path: String { "" }
    
    public var headers: [String : String]? {
        ["Authorization": "KakaoAK "]
    }
    
    public var task: Task {
        switch self {
        case .searchRegion(let query):
            return .requestParameters(parameters: ["query": query],
                                      encoding: URLEncoding.queryString)
        }
    }
}

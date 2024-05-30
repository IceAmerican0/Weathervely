//
//  MediumCategoryTarget.swift
//  Weatherbly
//
//  Created by Khai on 5/29/24.
//

import Moya

public enum MediumCategoryTarget {
    /// 타입 리스트 가져오기
    case getMediumCategoryList(id: [Int])
}

extension MediumCategoryTarget: WVTargetType {
    public var path: String { "/mediumCategory" }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task {
        switch self {
        case .getMediumCategoryList(let id):
            .requestParameters(
                parameters: [
                    "style_id": id
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}

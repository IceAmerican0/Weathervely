//
//  FilteredStyleTarget.swift
//  Weatherbly
//
//  Created by Khai on 6/3/24.
//

import Moya

public enum FilteredStyleTarget {
    /// 타입 리스트 가져오기
    case getFilteredStyledCount(id: [Int])
}

extension FilteredStyleTarget: WVTargetType {
    public var path: String { "" }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task {
        switch self {
        case .getFilteredStyledCount(let id):
            .requestParameters(
                parameters: [
                    "style_id": id,
                    "medium_category_ids": ""
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}

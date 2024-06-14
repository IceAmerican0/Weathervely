//
//  FilteredStyleTarget.swift
//  Weatherbly
//
//  Created by Khai on 6/3/24.
//

import Moya

public enum FilteredStyleTarget {
    /// 타입 리스트 가져오기
    case getFilteredStyleCount(id: [Int])
}

extension FilteredStyleTarget: WVTargetType {
    public var path: String { "" }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task {
        switch self {
        case .getFilteredStyleCount(let id):
            .requestParameters(
                parameters: [
                    "style_ids": UserDefaultManager.shared.homeStyleFilterList,
                    "medium_category_ids": id
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}

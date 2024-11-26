//
//  MediumCategoryTarget.swift
//  Weatherbly
//
//  Created by Khai on 5/29/24.
//

import UIUtil
import Moya

public enum MediumCategoryTarget {
    /// 타입 리스트 가져오기
    case getMainMediumCategoryList
    case getStyleMediumCategoryList(id: Int)
}

extension MediumCategoryTarget: WVTargetType {
    public var path: String { "/mediumCategory" }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task {
        switch self {
        case .getMainMediumCategoryList:
            .requestParameters(
                parameters: [
                    "tab": "main",
                    "style_ids": UserDefaultManager.shared.homeStyleFilterList.joined(separator: ",")
                ].removeEmptyParameters(),
                encoding: URLEncoding.queryString
            )
        case .getStyleMediumCategoryList(let id):
            .requestParameters(
                parameters: [
                    "tab": "style",
                    "style_ids": id
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}

//
//  NewClosetTarget.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya

public enum NewClosetTarget {
    /// 메인탭 코디 가져오기
    case getHomeCloset(
        style: [Int] = [],
        item: [Int] = [],
        page: Int
    )
    /// 스타일탭 코디 가져오기
    case getStyleCloset(
        style: [Int] = [],
        item: [Int] = [],
        page: Int
    )
}

extension NewClosetTarget: WVTargetType {
    public var path: String { "/closet" }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task {
        switch self {
        case .getHomeCloset(let style, let item, let page):
            .requestParameters(
                parameters: [
                    "tab": "main",
                    "style_id": style,
                    "medium_category_ids": item,
                    "page": page
                ],
                encoding: URLEncoding.queryString
            )
        case .getStyleCloset(let style, let item, let page):
                .requestParameters(
                    parameters: [
                        "tab": "style",
                        "style_id": style,
                        "medium_category_ids": item,
                        "page": page
                    ],
                    encoding: URLEncoding.queryString
                )
        }
    }
}

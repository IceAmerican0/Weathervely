//
//  NewClosetTarget.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya

public enum NewClosetTarget {
    /// 메인탭 코디 가져오기
    case getMainCloset(
        style: String,
        page: Int
    )
    /// 스타일탭 코디 가져오기
    case getStyleCloset(
        style: String,
        page: Int
    )
    /// 메인탭 필터 후 코디 가져오기
    case getMainFilteredCloset(
        page: Int,
        pageSize: Int,
        styleID: [String] = [""],
        category: [String] = [""]
    )
    /// 스타일탭 필터 후 코디 가져오기
    case getStyleFilteredCloset(
        page: Int,
        pageSize: Int,
        styleID: [String],
        category: [String]
    )
}

extension NewClosetTarget: WVTargetType {
    public var path: String { "/closet" }
    
    public var method: Moya.Method {
        switch self {
        case .getMainCloset,
             .getStyleCloset,
             .getMainFilteredCloset,
             .getStyleFilteredCloset: .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getMainCloset(let style, let page):
            .requestParameters(
                parameters: [
                    "style": style,
                    "page": page,
                    "pageSize": 20
                ],
                encoding: URLEncoding.queryString
            )
        case .getStyleCloset(let style, let page):
                .requestParameters(
                    parameters: [
                        "tab": "style",
                        "style": style,
                        "page": page,
                        "pageSize": 20
                    ],
                    encoding: URLEncoding.queryString
                )
        case .getMainFilteredCloset(let page, let pageSize, let styleID, let category):
                .requestParameters(
                    parameters: [
                        "page": page,
                        "pageSize": pageSize,
                        "styleIds": styleID,
                        "mediumCategoryIds": category
                    ],
                    encoding: URLEncoding.queryString
                )
        case .getStyleFilteredCloset(let page, let pageSize, let styleID, let category):
                .requestParameters(
                    parameters: [
                        "tab": "style",
                        "page": page,
                        "pageSize": pageSize,
                        "styleIds": styleID,
                        "mediumCategoryIds": category
                    ],
                    encoding: URLEncoding.queryString
                )
        }
    }
}

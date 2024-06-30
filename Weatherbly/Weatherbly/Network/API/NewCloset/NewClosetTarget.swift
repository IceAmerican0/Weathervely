//
//  NewClosetTarget.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya

public enum NewClosetTarget {
    /// 메인탭 코디 가져오기
    case getHomeCloset(page: Int)
    /// 스타일탭 코디 가져오기
    case getStyleCloset(style: Int, item: [Int], page: Int)
    /// 메인 > 메인 카드 클릭시 히스토리 저장
    case stylePicked(_ closetID: Int)
}

extension NewClosetTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getHomeCloset,
             .getStyleCloset:            "/closet"
        case .stylePicked(let closetID): "/closet/\(closetID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeCloset,
             .getStyleCloset:
            return .get
        case .stylePicked:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getHomeCloset(let page):
            .requestParameters(
                parameters: [
                    "page": page,
                    "tab": "style",
                    "style_ids": /*UserDefaultManager.shared.homeStyleFilterList*/14,
                    "medium_category_ids": /*UserDefaultManager.shared.homeItemFilterList*/[]
                ],
                encoding: URLEncoding.queryString
            )
        case .getStyleCloset(let style, let item, let page):
            .requestParameters(
                parameters: [
                    "page": page,
                    "tab": "style",
                    "style_ids": style,
                    "medium_category_ids": item
                ],
                encoding: URLEncoding.queryString
            )
        case .stylePicked:
            .requestPlain
        }
    }
}

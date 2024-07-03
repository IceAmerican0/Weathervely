//
//  NewClosetTarget.swift
//  Weatherbly
//
//  Created by Khai on 2/19/24.
//

import Moya

public enum NewClosetTarget {
    /// 메인탭 코디 가져오기
    case getHomeCloset(page: Int, time: String)
    /// 스타일탭 코디 가져오기
    case getStyleCloset(style: Int, item: [Int], page: Int)
    /// 메인 > 메인 카드 클릭시 히스토리 저장
    case stylePicked(_ closetID: Int)
    /// 필터탭 코디 개수 가져오기
    case getFilterCount(list: [String], time: String)
}

extension NewClosetTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getHomeCloset,
             .getStyleCloset,
             .getFilterCount:            "/closet"
        case .stylePicked(let closetID): "/closet/pick/\(closetID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeCloset,
             .getStyleCloset,
             .getFilterCount:
            return .get
        case .stylePicked:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getHomeCloset(let page, let time):
            .requestParameters(
                parameters: [
                    "page": page,
                    "tab": "main",
                    "dateTime": time,
                    "style_ids": UserDefaultManager.shared.homeStyleFilterList.joined(separator: ","),
                    "medium_category_ids": UserDefaultManager.shared.homeItemFilterList.joined(separator: ",")
                ].removeEmptyParameters(),
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
        case .getFilterCount(let list, let time):
            .requestParameters(
                parameters: [
                    "page": 1,
                    "tab": "main",
                    "dateTime": time,
                    "style_ids": UserDefaultManager.shared.homeStyleFilterList.joined(separator: ","),
                    "medium_category_ids": list.joined(separator: ",")
                ].removeEmptyParameters(),
                encoding: URLEncoding.queryString
            )
        }
    }
}

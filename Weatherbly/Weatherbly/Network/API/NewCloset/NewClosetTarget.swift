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
    case getClosetWithType(typeID: Int, page: Int)
    case getTypes
    case getCategories(typeID: Int)
    case closetWithCategory(typeID: Int, page: Int, items: [Int]?)
    /// 메인 > 메인 카드 클릭시 히스토리 저장
    case stylePicked(_ closetID: Int)
}

extension NewClosetTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getHomeCloset,
                .getClosetWithType,
                .closetWithCategory:
            "/closet"
        case .getTypes: "/type"
        case .getCategories: "/mediumCategory"
        case .stylePicked(let closetID): "/closet/\(closetID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeCloset,
                .getClosetWithType,
                .getTypes,
                .getCategories,
                .closetWithCategory:
            return .get
        case .stylePicked:
            return .post
        }
    }
    
    // return 값이 한줄 이상 단순텍스트가 아니라서 return 넣어주는 게 확인하기 용이 한 것 같아서 수정 함
    public var task: Moya.Task {
        switch self {
        case .getHomeCloset(let page):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "tab": "main",
                    "style_ids": /*UserDefaultManager.shared.homeStyleFilterList.joined(separator: ",")*/"7",
                    "medium_category_ids": /*UserDefaultManager.shared.homeItemFilterList.joined(separator: ",")*/""
                ],
                encoding: URLEncoding.queryString
            )
            
        case .getClosetWithType(let typeID, let page):
            return .requestParameters(
                parameters: [
                    "page" : page,
                    "tab" : "style",
                    "style_ids" : typeID
                ],
                encoding: URLEncoding.queryString
            )
            
        case .getTypes:
            return .requestPlain
            
        case .getCategories(let typeID):
            return .requestParameters(
                parameters: [
                    "tab" : "style",
                    "style_ids": typeID
                ],
                encoding: URLEncoding.queryString
            )
            
        case .closetWithCategory(let typeID, let page, let items):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "tab": "style",
                    "style_ids": typeID,
                    "medium_category_ids": items ?? []
                ],
                encoding: URLEncoding.queryString
            )
            
        case .stylePicked:
            return .requestPlain
        }
    }
}

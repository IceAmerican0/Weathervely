//
//  ClosetTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya

public enum ClosetTarget {
    /// 스타일 리스트 가져오기
    case getStyleList
    /// 메인 > 스타일 추천 리스트 가져오기
    case getRecommendStyleList(_ dateTime: String)
    /// 메인 > 메인 카드 클릭시 히스토리 저장
    case stylePicked(_ closetID: Int)
}

extension ClosetTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getStyleList:                   "/closet"
        case .getRecommendStyleList:          "/closet/getRecommendCloset"
        case .stylePicked(let closetID):      "/closet/pick/\(closetID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getStyleList,
             .getRecommendStyleList:
            return .get
        case .stylePicked:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getStyleList:
            .requestPlain
        case .getRecommendStyleList(let dateTime):
            .requestParameters(
                parameters: ["dateTime": dateTime],
                encoding: URLEncoding.queryString
            )
        case .stylePicked:
            .requestPlain
        }
    }
}

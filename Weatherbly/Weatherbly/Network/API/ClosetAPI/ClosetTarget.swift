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
    /// 스타일 선택
    case styleStylePickedList(_ closetIDs: [Int])
    /// 온보딩 > 체감온도 진입시 스타일 리스트 가져오기
    case getOnBoardClosetByTemperature(_ dateTime: String)
    /// 메인 > 체감온도 진입시 스타일 리스트 가져오기
    case getMainClosetByTemperature(_ dateTime: String, _ closetId: Int)
    /// 체감온도 설정
    case setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest)
    /// 메인 > 스타일 추천 리스트 가져오기
    case getRecommendStyleList(_ dateTime: String)
    /// 메인 > 메인 카드 클릭시 히스토리 저장
    case pagerViewClicked(_ closetID: Int)
}

extension ClosetTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getStyleList:                   "/closet"
        case .styleStylePickedList:           "/closet/pick"
        case .getOnBoardClosetByTemperature,
             .getMainClosetByTemperature:     "/closet/getClosetByTemperature"
        case .setSensoryTemperature:          "/closet/setTemperature"
        case .getRecommendStyleList:          "/closet/getRecommendCloset"
        case .pagerViewClicked(let closetID): "/closet/pick/\(closetID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getStyleList,
             .getOnBoardClosetByTemperature,
             .getMainClosetByTemperature,
             .getRecommendStyleList:
            return .get
        case .styleStylePickedList,
             .setSensoryTemperature,
             .pagerViewClicked:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getStyleList:
            .requestPlain
        case .styleStylePickedList(let closetIDs):
            .requestParameters(
                parameters: ["closet_ids": closetIDs],
                encoding: JSONEncoding.default
            )
        case .getOnBoardClosetByTemperature(let dateTime):
            .requestParameters(
                parameters: ["dateTime": dateTime],
                encoding: URLEncoding.queryString
            )
        case .getMainClosetByTemperature(let dateTime, let closetId):
            .requestParameters(
                parameters: [
                    "dateTime": dateTime,
                    "closet_id": closetId
                ],
                encoding: URLEncoding.queryString
            )
        case .setSensoryTemperature(let sensoryTempRequest):
            .requestParameters(
                parameters: [
                    "closet": sensoryTempRequest.closet,
                    "current_temperature": sensoryTempRequest.currentTemp,
                ],
                encoding: JSONEncoding.default
            )
        case .getRecommendStyleList(let dateTime):
            .requestParameters(
                parameters: ["dateTime": dateTime],
                encoding: URLEncoding.queryString
            )
        case .pagerViewClicked:
            .requestPlain
        }
    }
}

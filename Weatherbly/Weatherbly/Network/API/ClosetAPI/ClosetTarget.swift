//
//  ClosetTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya

public enum ClosetTarget { // TODO: 파라미터 값 변경
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
}

extension ClosetTarget: WBTargetType {
    public var path: String {
        switch self {
        case .getStyleList:
            return "/closet"
        case .styleStylePickedList:
            return "/closet/pick"
        case .getOnBoardClosetByTemperature,
             .getMainClosetByTemperature:
            return "/closet/getClosetByTemperature"
        case .setSensoryTemperature:
            return "/closet/setTemperature"
        case .getRecommendStyleList:
            return "/closet/getRecommendCloset"
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
             .setSensoryTemperature:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getStyleList:
            return .requestPlain
        case .styleStylePickedList(let closetIDs):
            return .requestParameters(parameters: ["closet_ids": closetIDs],
                                      encoding: JSONEncoding.default)
        case .getOnBoardClosetByTemperature(let dateTime):
            return .requestParameters(parameters: ["dateTime": dateTime],
                                      encoding: URLEncoding.queryString)
        case .getMainClosetByTemperature(let dateTime, let closetId):
            return .requestParameters(parameters: ["dateTime": dateTime,
                                                   "closet_id": closetId],
                                          encoding: URLEncoding.queryString)
        case .setSensoryTemperature(let sensoryTempRequest):
            return .requestParameters(parameters: ["closet": sensoryTempRequest.closet,
                                                   "current_temperature": sensoryTempRequest.currentTemp,
                                                  ],
                                      encoding: JSONEncoding.default)
        case .getRecommendStyleList(let dateTime):
            return .requestParameters(parameters: ["dateTime": dateTime],
                                      encoding: URLEncoding.queryString)
        }
    }
}

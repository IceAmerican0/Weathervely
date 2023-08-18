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
    case getSensoryTemperatureCloset(_ dateTime: String)
    /// 체감온도 설정
    case setSensoryTemperature(_ sensoryTempRequest: SetSensoryTempRequest)
    /// 메인 > 스타일 추천 리스트 가져오기
    case getRecommendStyleList(_ dateTime: String)
}

extension ClosetTarget: WBTargetType {
    public var path: String {
        switch self {
        case .getStyleList:
            return "/v1/closet"
        case .styleStylePickedList:
            return "/v1/closet/pick"
        case .getSensoryTemperatureCloset:
            return "/v1/closet/getClosetByTemperature"
        case .setSensoryTemperature:
            return "/v1/closet/setTemperature"
        case .getRecommendStyleList:
            return "/v1/closet/getRecommendCloset"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getStyleList,
             .getSensoryTemperatureCloset,
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
        case .getSensoryTemperatureCloset(let dateTime):
            return .requestParameters(parameters: ["dateTime": dateTime],
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

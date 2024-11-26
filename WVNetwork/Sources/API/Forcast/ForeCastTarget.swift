//
//  ForcastTarget.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import Moya
import Foundation

public enum ForeCastTarget {
    case getVillageForcastInfo
    case getTenDayForecastInfo
}

extension ForeCastTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getVillageForcastInfo: "/forecast/getVilageForecastInfo"
        case .getTenDayForecastInfo: "/forecast/getTenDayForecastInfo"
        }
    }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task { .requestPlain }
}

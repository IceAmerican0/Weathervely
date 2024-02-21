//
//  ForcastTarget.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import Moya
import Foundation

enum ForeCastTarget {
    case getVillageForcastInfo
    case getTenDayForecastInfo
}

extension ForeCastTarget: WVTargetType {
    var path: String {
        switch self {
        case .getVillageForcastInfo:
            return "/forecast/getVilageForecastInfo"
        case .getTenDayForecastInfo:
            return "/forecast/getTenDayForecastInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVillageForcastInfo,
             .getTenDayForecastInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getVillageForcastInfo,
             .getTenDayForecastInfo:
            return .requestPlain
        }
    }
    
}

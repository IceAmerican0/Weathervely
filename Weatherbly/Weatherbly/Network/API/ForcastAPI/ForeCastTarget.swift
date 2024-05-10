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
        case .getVillageForcastInfo: "/forecast/getVilageForecastInfo"
        case .getTenDayForecastInfo: "/forecast/getTenDayForecastInfo"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task {
        switch self {
        case .getVillageForcastInfo,
             .getTenDayForecastInfo: .requestPlain
        }
    }
    
}

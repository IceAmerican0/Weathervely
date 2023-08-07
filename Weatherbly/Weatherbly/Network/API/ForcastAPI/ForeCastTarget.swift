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
}

extension ForeCastTarget: WBTargetType {
    var path: String {
        switch self {
        case .getVillageForcastInfo:
            return "/forecast/getVilageForecastInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVillageForcastInfo:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getVillageForcastInfo:
            return .none
        }
    }
    
    
    var task: Moya.Task {
        switch self {
        case .getVillageForcastInfo:
            return .requestPlain
        }
    }
    
}

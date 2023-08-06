//
//  ForcastTarget.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import Moya
import Foundation

enum ForeCastTarget {
    case getVilageForcastInfo
}

extension ForeCastTarget: WBTargetType {
    var path: String {
        switch self {
        case .getVilageForcastInfo:
            return "/forecast/getVilageForecastInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVilageForcastInfo:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getVilageForcastInfo:
            return .none
        }
    }
    
    
    var task: Moya.Task {
        switch self {
        case .getVilageForcastInfo:
            return .requestPlain
        }
    }
    
}

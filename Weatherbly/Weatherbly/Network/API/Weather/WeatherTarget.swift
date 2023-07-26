//
//  WeatherTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/26.
//

import Foundation
import Moya

public enum WeatherTarget {
    case daily(_ request: String)
    case now(_ request: String)
    case tenDays(_ request: String)
}

extension WeatherTarget: WBTargetType {
    public var method: Moya.Method { .get }
    
    public var path: String { "" }
    
    public var task: Task {
        switch self {
        case .daily(let request):
            return .requestParameters(parameters: ["": request], encoding: URLEncoding.queryString)
        case .now(let request):
            return .requestParameters(parameters: ["": request], encoding: URLEncoding.queryString)
        case .tenDays(let request):
            return .requestParameters(parameters: ["": request], encoding: URLEncoding.queryString)
        }
    }
}

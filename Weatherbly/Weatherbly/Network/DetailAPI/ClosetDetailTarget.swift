//
//  ClosetDetailTarget.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/11/24.
//

import Moya

public enum ClosetDetailTarget {
    case closetDetail(_ closetID: Int)
    case warammerTemp(_ closetID: Int, page: Int)
    case coolerTemp(_ closetID: Int, page: Int)
}

extension ClosetDetailTarget: WVTargetType {
    public var path: String {
        switch self {
        case .closetDetail(let closetId):
            return "/closet/\(closetId)"
        case .warammerTemp(let closetId, _):
            return "/closet/\(closetId)/higherTemperature"
        case .coolerTemp(let closetId, _):
            return "/closet/\(closetId)/lowerTemperature"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .closetDetail: return .get
        case .warammerTemp: return .get
        case .coolerTemp: return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .closetDetail(let id):
            return .requestPlain
        case .warammerTemp(_, let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        case .coolerTemp(_, let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        }
    }
    
    
}

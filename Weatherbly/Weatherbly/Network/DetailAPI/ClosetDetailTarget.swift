//
//  ClosetDetailTarget.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/11/24.
//

import Moya

public enum ClosetDetailTarget {
    case closetDetail(_ closetID: Int)
    case warmerTemp(_ closetID: Int, page: Int)
    case warmerRows(_ closetID: Int, page: Int, row: Int)
    case coolerTemp(_ closetID: Int, page: Int)
    case coolerRows(_ closetID: Int, page: Int, row: Int)
}

extension ClosetDetailTarget: WVTargetType {
    public var path: String {
        switch self {
        case .closetDetail(let closetId):
            return "/closet/\(closetId)"
        case .warmerTemp(let closetId, _),
                .warmerRows(let closetId, _, _):
            return "/closet/\(closetId)/higherTemperature"
        case .coolerTemp(let closetId, _),
                .coolerRows(let closetId, _, _):
            return "/closet/\(closetId)/lowerTemperature"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .closetDetail: return .get
        case .warmerTemp, .warmerRows: return .get
        case .coolerTemp, .coolerRows: return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .closetDetail(let id):
            return .requestPlain
        case .warmerTemp(_, let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
            
        case .warmerRows(_, let page, let row):
            return .requestParameters(parameters: ["page" : page, "row" : row], encoding: URLEncoding.queryString)
            
        case .coolerTemp(_, let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
            
        case .coolerRows(_, let page, let row):
            return .requestParameters(parameters: ["page" : page, "row" : row], encoding: URLEncoding.queryString)
        }
    }
    
    
}

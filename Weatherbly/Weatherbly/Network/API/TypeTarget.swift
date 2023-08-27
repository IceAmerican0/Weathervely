//
//  TypeTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya

public enum TypeTarget {
    /// 타입 리스트 가져오기
    case getTypeList
}

extension TypeTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getTypeList:
            return "/type"
        }
    }
    
    public var method: Moya.Method { .get }
    
    public var task: Moya.Task {
        switch self {
        case .getTypeList:
            return .requestPlain
        }
    }
}

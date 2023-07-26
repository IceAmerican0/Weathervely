//
//  LoginTarget.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import Foundation
import Moya

enum LoginTarget {
    case login(nickname: String)
}

extension LoginTarget: WBTargetType {
    
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        }
    }
    var task: Moya.Task {
        switch self {
        case .login(let nickname):
            return .requestParameters(parameters: ["nickname" : nickname], encoding: JSONEncoding.default) // TODO: - nickname 가져와서 붙이기
        }
    }
    
    
    
}


//
//  AuthTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya

public enum AuthTarget {
    /// 임시 토큰 발행
    case login(_ nickname: String)
    /// 닉네임 설정
    case nickname(_ nickname: String)
    /// 주소 설정
    case address(_ addressInfo: AddressRequest)
    /// 성별 설정
    case gender(_ gender: String)
}

extension AuthTarget: WBTargetType {
    public var path: String {
        switch self {
        case .login:
            return "/v1/auth/login"
        case .nickname:
            return "/v1/auth/nickName"
        case .address:
            return "/v1/auth/address"
        case .gender:
            return "/v1/auth/gender"
        }
    }
    
    public var method: Moya.Method { .post }
    
    public var task: Moya.Task {
        switch self {
        case .login(let nickname),
             .nickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname],
                                      encoding: JSONEncoding.default)
        case .address(let addressInfo):
            return .requestParameters(parameters: addressInfo.dictionary,
                                      encoding: JSONEncoding.default)
        case .gender(let gender):
            return .requestParameters(parameters: ["gender": gender],
                                      encoding: JSONEncoding.default)
        }
    }
}

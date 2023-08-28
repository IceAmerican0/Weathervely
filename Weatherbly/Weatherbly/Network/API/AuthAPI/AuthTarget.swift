//
//  AuthTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Foundation
import Moya

public enum AuthTarget {
    /// 임시 토큰 발행
    case login
    /// 닉네임 설정
    case nickname(_ nickname: String, _ uuid: String)
    /// 주소 설정
    case address(_ addressInfo: AddressRequest)
    /// 성별 설정
    case gender(_ gender: String)
}

extension AuthTarget: WVTargetType {
    public var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .nickname:
            return "/auth/nickName"
        case .address:
            return "/auth/address"
        case .gender:
            return "/auth/gender"
        }
    }
    
    public var method: Moya.Method { .post }
    
    public var task: Moya.Task {
        switch self {
        case .login:
            return .requestParameters(parameters: ["phone_id": UserDefaultManager.shared.uuid],
                                      encoding: JSONEncoding.default)
        case .nickname(let nickname, let uuid):
            return .requestParameters(parameters: ["nickname": nickname,
                                                   "phone_id": uuid
                                                  ],
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

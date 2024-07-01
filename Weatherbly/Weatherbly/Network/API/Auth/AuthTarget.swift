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
    case login(_ agreement: Bool)
    /// 닉네임 중복 검증
    case nicknameValidation(_ nickname: String)
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
        case .login:              "/auth/login"
        case .nicknameValidation: "/auth/validatedNickName"
        case .nickname:           "/auth/nickName"
        case .address:            "/auth/address"
        case .gender:             "/auth/gender"
        }
    }
    
    public var method: Moya.Method { .post }
    
    public var task: Moya.Task {
        switch self {
        case .login(let agreement):
            .requestParameters(
                parameters: [
                    "phone_id": UserDefaultManager.shared.uuid,
                    "fcm_phone_token": UserDefaultManager.shared.pushToken,
                    "is_notification": agreement
                ],
                encoding: JSONEncoding.default
            )
        case .nicknameValidation(let nickname):
            .requestParameters(
                parameters: [
                    "nickname": nickname,
                    "fcm_phone_token": UserDefaultManager.shared.pushToken,
                    "is_notification": UserDefaultManager.shared.pushAgreement,
                ],
                encoding: JSONEncoding.default
            )
        case .nickname(let nickname, let uuid):
            .requestParameters(
                parameters: [
                    "nickname": nickname,
                    "phone_id": uuid
                ],
                encoding: JSONEncoding.default
            )
        case .address(let addressInfo):
            .requestParameters(
                parameters: addressInfo.dictionary,
                encoding: JSONEncoding.default
            )
        case .gender(let gender):
            .requestParameters(
                parameters: ["gender": gender],
                encoding: JSONEncoding.default
            )
        }
    }
}

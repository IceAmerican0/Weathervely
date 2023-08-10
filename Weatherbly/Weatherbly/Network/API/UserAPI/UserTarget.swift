//
//  UserTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import Foundation

public enum UserTarget { // TODO: 파라미터 값 수정
    /// 유저 정보 가져오기
    case getUserInfo(_ nickname: String)
    /// 유저 정보 수정
    case fetchUserInfo(_ userInfo: UserInfoRequest)
    /// 주소 리스트 가져오기
    case getAddressList(_ nickname: String)
    /// 주소 추가
    case addAddress(_ addressInfo: AddressRequest)
    /// 설정된 주소 변경
    case fetchAddress(_ targetID: Int, _ addressInfo: AddressRequest)
    /// 설정된 주소 삭제
    case deleteAddress(_ targetID: Int, _ addressInfo: AddressRequest)
}

extension UserTarget: WBTargetType {
    public var path: String {
        switch self {
        case .getUserInfo,
             .fetchUserInfo:
            return "/user"
        case .getAddressList,
             .addAddress:
            return "/user/address"
        case .fetchAddress(let targetID, _),
             .deleteAddress(let targetID, _):
            return "/user/address/\(targetID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getAddressList:
            return .get
        case .addAddress,
             .deleteAddress:
            return .post
        case .fetchUserInfo,
             .fetchAddress:
            return .patch
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getUserInfo(let nickname):
            return .requestParameters(parameters: ["nickname": nickname],
                                      encoding: URLEncoding.queryString)
        case .fetchUserInfo(let userInfo):
            return .requestParameters(parameters: userInfo.dictionary,
                                      encoding: JSONEncoding.default)
        case .getAddressList(let nickname):
            return .requestParameters(parameters: ["nickname": nickname],
                                      encoding: URLEncoding.queryString)
        case .addAddress(let addressInfo):
            return .requestParameters(parameters: addressInfo.dictionary,
                                      encoding: JSONEncoding.default)
        case .fetchAddress(_, let addressInfo):
            return .requestParameters(parameters: addressInfo.dictionary,
                                      encoding: JSONEncoding.default)
        case .deleteAddress(_, let addressID):
            return .requestParameters(parameters: ["addressId": addressID],
                                      encoding: JSONEncoding.default)
        }
    }
}

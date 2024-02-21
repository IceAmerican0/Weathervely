//
//  UserTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Moya
import Foundation

public enum UserTarget {
    /// 유저 정보 가져오기
    case getUserInfo(_ nickname: String)
    /// 유저 정보 수정
    case fetchUserInfo(_ userInfo: UserInfoRequest)
    /// 주소 리스트 가져오기
    case getAddressList
    /// 주소 추가
    case addAddress(_ addressInfo: AddressRequest)
    /// 메인 주소 설정
    case setMainAddress(_ addressID: Int)
    /// 설정된 주소 변경
    case fetchAddress(_ addressID: Int, _ addressInfo: AddressRequest)
    /// 설정된 주소 삭제
    case deleteAddress(_ addressID: Int)
}

extension UserTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getUserInfo,
             .fetchUserInfo:
            return "/user"
        case .getAddressList,
             .addAddress:
            return "/user/address"
        case .fetchAddress(let addressID, _),
             .deleteAddress(let addressID):
            return "/user/address/\(addressID)"
        case .setMainAddress(let addressID):
            return "/user/address/setMain/\(addressID)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getAddressList:
            return .get
        case .addAddress,
             .setMainAddress,
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
        case .getAddressList:
            return .requestPlain
        case .addAddress(let addressInfo):
            return .requestParameters(parameters: addressInfo.dictionary,
                                      encoding: JSONEncoding.default)
        case .fetchAddress(_, let addressInfo):
            return .requestParameters(parameters: addressInfo.dictionary,
                                      encoding: JSONEncoding.default)
        case .setMainAddress(let addressID),
             .deleteAddress(let addressID):
            return .requestParameters(parameters: ["addressId": addressID],
                                      encoding: JSONEncoding.default)
        }
    }
}

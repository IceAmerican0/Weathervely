//
//  UserTarget.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import UIUtil
import Moya
import Foundation

public enum UserTarget {
    /// 유저 정보 가져오기
    case getUserInfo
    /// 유저 정보 수정
    case fetchUserInfo(_ userInfo: UserInfoRequest)
    /// 유저 정보 초기화(테스트용 정보 삭제)
    case resetUserInfo(_ userID: Int)
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
    /// FCM Token 변경
    case fetchFCMToken(_ token: String)
    /// 푸시 동의여부 변경
    case fetchPushAgreement(_ agreement: Bool)
    /// 유저 버전 수정
    case fetchUserVersion
}

extension UserTarget: WVTargetType {
    public var path: String {
        switch self {
        case .getUserInfo,
             .fetchUserInfo:                    "/user"
        case .resetUserInfo(let userID):        "/user/\(userID)"
        case .getAddressList,
             .addAddress:                       "/user/address"
        case .fetchAddress(let addressID, _),
             .deleteAddress(let addressID):     "/user/address/\(addressID)"
        case .setMainAddress(let addressID):    "/user/address/setMain/\(addressID)"
        case .fetchFCMToken:                    "/user/fcmPhoneToken"
        case .fetchPushAgreement:               "/user/isNotification"
        case .fetchUserVersion:                 "/user/version"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getAddressList:
            return .get
        case .resetUserInfo,
             .addAddress,
             .setMainAddress,
             .deleteAddress:
            return .post
        case .fetchUserInfo,
             .fetchAddress,
             .fetchFCMToken,
             .fetchPushAgreement,
             .fetchUserVersion:
            return .patch
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getUserInfo,
             .resetUserInfo,
             .getAddressList:
            .requestPlain
        case .fetchUserInfo(let userInfo):
            .requestParameters(
                parameters: userInfo.dictionary,
                encoding: JSONEncoding.default
            )
        case .addAddress(let addressInfo):
            .requestParameters(
                parameters: addressInfo.dictionary,
                encoding: JSONEncoding.default
            )
        case .fetchAddress(_, let addressInfo):
            .requestParameters(
                parameters: addressInfo.dictionary,
                encoding: JSONEncoding.default
            )
        case .setMainAddress(let addressID),
             .deleteAddress(let addressID):
            .requestParameters(
                parameters: ["addressId": addressID],
                encoding: JSONEncoding.default
            )
        case .fetchFCMToken(let token):
            .requestParameters(
                parameters: ["fcm_phone_token": token],
                encoding: JSONEncoding.default
            )
        case .fetchPushAgreement(let agreement):
            .requestParameters(
                parameters: ["is_notification": agreement],
                encoding: JSONEncoding.default
            )
        case .fetchUserVersion:
            .requestParameters(
                parameters: ["version": Constants.bundleShortVersion],
                encoding: JSONEncoding.default
            )
        }
    }
}

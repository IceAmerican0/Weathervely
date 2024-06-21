//
//  UserDefaultKey.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/07.
//

import Foundation

public let userDefault = UserDefaults.standard

public enum UserDefaultKey: String {
    /// 서버
    case appEnvironment
    /// 서버 변경여부
    case isServerChanged
    /// 온보딩 진행여부
    case isOnboard
    /// 알림 수신여부
    case pushAgreement
    /// 닉네임
    case nickname
    /// 푸시토큰
    case pushToken
    /// 유저성별
    case gender
    /// 코디ID
    case closetID
    /// 변경 대상 주소
    case regionID
    /// 동
    case dong
    /// 주소 정보
    case regionInfo
    /// 홈 스타일 필터 리스트
    case homeStyleFilterList
    /// 홈 아이템 필터 리스트
    case homeItemFilterList
}

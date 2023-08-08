//
//  UserDefaultManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/07.
//

import Foundation

public final class UserDefaultManager {
    public static let shared = UserDefaultManager()
    
    public var isOnBoard: Bool {
        if let isOnboard = userDefault.object(forKey: UserDefaultKey.isOnboard.rawValue) {
            return true
        } else {
            return false
        }
    }
    
    public var nickname: String {
        if let nickname = userDefault.object(forKey: UserDefaultKey.nickname.rawValue) {
            return "\(nickname)"
        } else {
            return "알수없음"
        }
    }
    
    public var gender: String {
        if let gender = userDefault.object(forKey: UserDefaultKey.gender.rawValue) {
            return "\(gender)"
        } else {
            return "여성"
        }
    }
}

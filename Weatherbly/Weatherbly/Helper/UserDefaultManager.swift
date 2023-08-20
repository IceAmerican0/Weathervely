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
        if userDefault.object(forKey: UserDefaultKey.isOnboard.rawValue) != nil {
            return true
        } else {
            return false
        }
    }
    
    public var nickname: String {
        if let nickname = userDefault.object(forKey: UserDefaultKey.nickname.rawValue) {
            return "\(nickname)"
        } else {
            return ""
        }
    }
    
    public var gender: String {
        return isFemale ? "여성" : "남성"
    }
    
    public var isFemale: Bool {
        if let gender = userDefault.object(forKey: UserDefaultKey.gender.rawValue) {
            return gender as! String == "female" ? true : false
        } else {
            return false
        }
    }
    
    public var regionID: Int {
        if let regionID = userDefault.object(forKey: UserDefaultKey.regionID.rawValue) {
            return regionID as! Int
        } else {
            return 0
        }
    }
    
    public var closetID: Int {
        if let closetID = userDefault.object(forKey: UserDefaultKey.closetID.rawValue) {
            return closetID as! Int
        } else {
            return 0
        }
    }
}

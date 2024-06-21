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
    
    public var uuid: String {
        if let storedUUID = KeychainManager.shared.getUUID() {
            return storedUUID
        } else {
            return ""
        }
    }
    
    public var pushAgreement: Bool {
        if let agreement = userDefault.object(forKey: UserDefaultKey.pushAgreement.rawValue) as? Bool {
            agreement
        } else {
            false
        }
    }
    
    public var pushToken: String {
        if let pushToken = userDefault.object(forKey: UserDefaultKey.pushToken.rawValue) {
            return "\(pushToken)"
        } else {
            return ""
        }
    }
    
    public var gender: String {
        return isFemale ? "여성" : "남성"
    }
    
    public var isFemale: Bool {
        if let gender = userDefault.object(forKey: UserDefaultKey.gender.rawValue) as? String {
            return gender == "female" ? true : false
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
        if let closetID = userDefault.object(forKey: UserDefaultKey.closetID.rawValue) as? Int {
            return closetID
        } else {
            return 0
        }
    }
    
    public var dong: String {
        if let dong = userDefault.object(forKey: UserDefaultKey.dong.rawValue) {
            return "\(dong)"
        } else {
            return "00동"
        }
    }
    
    public var environmentType: EnvironmentType {
        if let appEnvironment = userDefault.object(forKey: UserDefaultKey.appEnvironment.rawValue) as? String {
            return appEnvironment == "production" ? .production : .develop
        } else {
            #if DEBUG
                return .develop
            #else
                return .production
            #endif
        }
    }
    
    public var isServerChanged: Bool {
        if let isServerChanged = userDefault.object(forKey: UserDefaultKey.isServerChanged.rawValue) as? Bool {
            true
        } else {
            false
        }
    }
    
    public var homeStyleFilterList: [Int] {
        if let list = userDefault.object(forKey: UserDefaultKey.homeStyleFilterList.rawValue) as? [Int] {
            return list
        } else {
            return []
        }
    }
    
    public func filteringStyle(id: Int) {
        var filteredList = UserDefaultManager.shared.homeStyleFilterList
        if let index = filteredList.firstIndex(of: id) {
            filteredList.remove(at: index)
        } else {
            filteredList.append(id)
        }
        userDefault.set(filteredList, forKey: UserDefaultKey.homeStyleFilterList.rawValue)
    }
    
    public var homeItemFilterList: [Int] {
        if let list = userDefault.object(forKey: UserDefaultKey.homeItemFilterList.rawValue) as? [Int] {
            return list
        } else {
            return []
        }
    }
}

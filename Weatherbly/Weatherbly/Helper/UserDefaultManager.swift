//
//  UserDefaultManager.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/07.
//

import Foundation

public struct UserDefaultManager {
    public func isOnBoard() -> Bool {
        if let isOnboard = userDefault.object(forKey: UserDefaultKey.isOnboard.rawValue) {
            return true
        } else {
            return false
        }
    }
}

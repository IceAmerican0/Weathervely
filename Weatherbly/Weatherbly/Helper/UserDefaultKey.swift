//
//  UserDefaultKey.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/07.
//

import Foundation

public let userDefault = UserDefaults.standard

public enum UserDefaultKey: String {
    case isOnboard
    case nickname
    case gender
    case region
}

//
//  WVTargetType.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import UIUtil
import Foundation
import Moya

public protocol WVTargetType: TargetType {}

public extension WVTargetType {
    var baseURL: URL { AppEnvironment.shared.environmentType.baseURL }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}

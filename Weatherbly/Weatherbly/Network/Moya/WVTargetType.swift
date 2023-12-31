//
//  WVTargetType.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation
import Moya

/// WVTargetType 에 사용되는 Target에 대한 Protocol
/// # 공통적으로 사용되는 baseURL, header (예정)
/// # 해당 프로토콜을 따르는 타겟들은 path, method, task 만 정의해도 사용할 수 있다.

public protocol WVTargetType: TargetType {}

public extension WVTargetType {
    var baseURL: URL {
        #if DEBUG
        return URL(string: "")!
        #else
        return URL(string: "")!
        #endif
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}

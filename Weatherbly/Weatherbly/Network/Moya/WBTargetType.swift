//
//  WBTargetType.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation
import Moya

public protocol WBTargetType: TargetType {}

public extension WBTargetType {
    var baseURL: URL {
        NetworkManager.shared.baseURL
    }
    
    var method: Moya.Method { .get }
    
    var path: String { "" }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}

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
        // 운영서버 테스트시 주석 해제
        // userDefault.set(EnvironmentType.production, forKey: UserDefaultKey.appEnvironment.rawValue)
        guard let version = Constants.bundleShortVersion.first else { return URL(string: "")! }
        
        return switch AppSetting.shared.environmentType {
        case .production: URL(string: "\(Constants.releaseServerURL)/v\(version)")!
        case .develop:    URL(string: "\(Constants.testServerURL)/v\(version)")!
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}

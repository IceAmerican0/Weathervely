//
//  AppEnvironment.swift
//  Weatherbly
//
//  Created by Khai on 3/28/24.
//

import Foundation

public enum EnvironmentType: String, CaseIterable {
    case production
    case develop
    
    public var baseURL: URL {
        let version = Constants.bundleShortVersion.first ?? "2"
        
        return switch self {
        case .production: URL(string: "\(Constants.releaseServerURL)/v\(version)")!
        case .develop:    URL(string: "\(Constants.testServerURL)/v\(version)")!
        }
    }
}

public protocol AppEnvironmentProtocol {
    var environmentType: EnvironmentType { get }
}

public class AppEnvironment: AppEnvironmentProtocol {
    public static var shared = AppEnvironment()
    
    public var environmentType: EnvironmentType {
        UserDefaultManager.shared.environmentType
    }
}

/// 개발 서버 로그
public func debugPrint(_ text: String) {
    if case .develop = AppEnvironment.shared.environmentType {
        print(text)
        return
    }
    
    // 빌드시 운영서버일 경우에도 로그 남김
    #if DEBUG
        print(text)
    #endif
}

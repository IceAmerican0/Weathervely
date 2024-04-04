//
//  AppEnvironment.swift
//  Weatherbly
//
//  Created by Khai on 3/28/24.
//

public enum EnvironmentType: String, CaseIterable {
    case production
    case develop
}

public protocol AppEnvironmentProtocol {
    var environmentType: EnvironmentType { get }
}

public class AppSetting: AppEnvironmentProtocol {
    public static var shared = AppSetting()
    
    public var environmentType: EnvironmentType {
        UserDefaultManager.shared.environmentType
    }
}

//
//  Constants.swift
//  Weatherbly
//
//  Created by 60156056 on 2023/08/29.
//

import Foundation

public class Constants {
    private static func fetchValue(for key: String) -> Any? {
        Bundle.main.infoDictionary?[key]
    }
    
    /// Bundle Version String (short)
    public static var bundleShortVersion: String {
        fetchValue(for: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    
    /// Build Version
    public static var buildVersion: String {
        fetchValue(for: "CFBundleVersion") as? String ?? "1.0.0.0"
    }
}

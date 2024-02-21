//
//  Constants.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/29.
//

import UIKit

public enum Constants {
    private static func fetchValue(for key: String) -> Any? {
        Bundle.main.infoDictionary?[key]
    }
    /// Bundle Display Name
    public static var bundleDisplayName: String {
        fetchValue(for: "CFBundleDisplayName") as? String ?? "웨더블리"
    }
    /// Bundle Version String (short)
    public static var bundleShortVersion: String {
        fetchValue(for: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    /// Build Version
    public static var buildVersion: String {
        fetchValue(for: "CFBundleVersion") as? String ?? "1.0.0.0"
    }
    /// AppStore Link
    public static var appStoreLink: String {
        "https://apps.apple.com/app/%EC%9B%A8%EB%8D%94%EB%B8%94%EB%A6%AC/id6462055767"
    }
    /// Screen Width
    static let screenWidth = UIScreen.main.bounds.width
    /// Screen Height
    static let screenHeight = UIScreen.main.bounds.height
}

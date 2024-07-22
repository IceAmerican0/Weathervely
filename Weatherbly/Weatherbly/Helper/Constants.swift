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
        fetchValue(for: "CFBundleShortVersionString") as? String ?? "2.0.0"
    }
    /// Build Version
    public static var buildVersion: String {
        fetchValue(for: "CFBundleVersion") as? String ?? "0.0.0"
    }
    /// AppStore Link
    public static var appStoreLink: String {
        "https://apps.apple.com/app/%EC%9B%A8%EB%8D%94%EB%B8%94%EB%A6%AC/id6462055767"
    }
    /// KAKAO_APP_KEY
    public static var kakaoAppKey: String {
        fetchValue(for: "KAKAO_APP_KEY") as? String ?? ""
    }
    /// RELEASE_SERVER_URL
    public static var releaseServerURL: String {
        fetchValue(for: "RELEASE_SERVER_URL") as? String ?? ""
    }
    /// TEST_SERVER_URL
    public static var testServerURL: String {
        fetchValue(for: "TEST_SERVER_URL") as? String ?? ""
    }
    /// Screen Width
    static let screenWidth = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.screen.bounds.size.width
    /// Screen Height
    static let screenHeight = UIScreen.main.bounds.height
}

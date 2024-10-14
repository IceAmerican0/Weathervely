import ProjectDescription

public typealias Dep = TargetDependency

extension Dep {
    public struct SPM {}
}

public extension Dep.SPM {
    // Base
    static let RxSwift              = Dep.external(name: "RxSwift")
    static let RxCocoa              = Dep.external(name: "RxCocoa")
    static let RxRelay              = Dep.external(name: "RxRelay")
    static let RxDataSources        = Dep.external(name: "RxDataSources")
    static let RxGesture            = Dep.external(name: "RxGesture")
    
    // Network
    static let Moya                 = Dep.external(name: "Moya")
    static let RxMoya               = Dep.external(name: "RxMoya")
    static let Kingfisher           = Dep.external(name: "Kingfisher")
    
    // Utility
    static let Then                 = Dep.external(name: "Then")
    
    // Data
    static let KeychainAccess       = Dep.external(name: "KeychainAccess")
    
    // UI
    static let FlexLayout           = Dep.external(name: "FlexLayout")
    static let PinLayout            = Dep.external(name: "PinLayout")

    // ETC
    static let FirebaseAnalytics    = Dep.external(name: "FirebaseAnalytics")
    static let FirebaseCrashlytics  = Dep.external(name: "FirebaseCrashlytics")
    static let FirebaseMessaging    = Dep.external(name: "FirebaseMessaging")
    static let FirebaseRemoteConfig = Dep.external(name: "FirebaseRemoteConfig")
    static let KakaoMapsSDK         = Dep.external(name: "KakaoMapsSDK-SPM")
}


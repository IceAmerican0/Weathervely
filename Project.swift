import ProjectDescription

let project = Project(
    name: "Weathervely",
    targets: [
        .target(
            name: "Weathervely",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.redthree.weathervely",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: .relativeToRoot("Weathervely/Resources/Info.plist")),
            sources: [
                .glob(.relativeToRoot("Weathervely/Sources/**"))
            ],
            resources: [
                .glob(pattern: .relativeToRoot("Weathervely/Configurations/Common.xcconfig")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/LaunchScreen.storyboard")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/Font/**")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/Colors.xcassets")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/Images.xcassets")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/GoogleService-Info.plist")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/PrivacyInfo.xcprivacy"))
            ],
            scripts: [
                .pre(
                    script: """
                            if [ "${CONFIGURATION}" != "Debug" ]; then
                                "${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
                            fi
                            """,
                    name: "Firebase Crashlytics"
                ),
                .pre(
                    script: """
                            BUILD_NUMBER_WITH_CURRENT_DATE=$(date "+%Y.%m.%d.%H.%M")

                            /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_NUMBER_WITH_CURRENT_DATE}" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
                            """,
                    name: "Run Script - Build Number",
                    runForInstallBuildsOnly: true
                )
            ],
            dependencies: [
                .SPM.RxSwift,
                .SPM.RxCocoa,
                .SPM.RxRelay,
                .SPM.RxDataSources,
                .SPM.RxGesture,
                .SPM.Moya,
                .SPM.RxMoya,
                .SPM.Kingfisher,
                .SPM.Then,
                .SPM.KeychainAccess,
                .SPM.FlexLayout,
                .SPM.PinLayout,
                .SPM.FirebaseAnalytics,
                .SPM.FirebaseCrashlytics,
                .SPM.FirebaseMessaging,
                .SPM.FirebaseRemoteConfig,
                .SPM.KakaoMapsSDK
            ],
            settings: Settings.settings(
                base: SettingsDictionary()
                    .automaticCodeSigning(devTeam: "$(DEVELOPMENT_TEAM)")
                    .merging([
                        "PRODUCT_BUNDLE_IDENTIFIER": "$(BUNDLE_ID)",
                        "CODE_SIGN_STYLE": "$(CODE_SIGN_STYLE)",
                        "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
                        "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
                        "PROVISIONING_PROFILE_SPECIFIER": "$(PROVISIONING_PROFILE)",
                        "OTHER_LDFLAGS" : "$(inherited) -all_load"
                    ])
                ,
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: ["GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1"],
                        xcconfig: .relativeToRoot("Weathervely/Configurations/Debug.xcconfig")
                    ),
                    .release(
                        name: "Release",
                        xcconfig: .relativeToRoot("Weathervely/Configurations/Release.xcconfig")
                    )
                ],
                defaultSettings: .recommended(excluding: [
                    "GCC_PREPROCESSOR_DEFINITIONS"
                ])
            )
        )
    ],
    resourceSynthesizers: [
        .plists()
    ]
)

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
